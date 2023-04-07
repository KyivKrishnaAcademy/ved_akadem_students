class RegistrationWizardsController < ApplicationController
  skip_before_action :ensure_registration_complete

  before_action :set_current_step

  STEPS = {
    'sign_up' => {
      interaction: Active::RegistrationWizard::SignUpStepInteraction
    },
    'agreement' => {
      interaction: Active::RegistrationWizard::AgreementStepInteraction
    },
    'identification' => {
      interaction: Active::RegistrationWizard::IdentificationStepInteraction
    }
  }

  def edit
    @form_resource = current_person

    render_edit_view
  end

  def update
    interaction = STEPS[@current_step][:interaction].run(params_for_interaction)

    if interaction.result&.persisted?
      NotifyVerificationExpiredJob.perform_later(current_person.id)

      redirect_to after_registration_path
    else
      @form_resource = interaction

      render_edit_view
    end
  end

  private

  def params_for_interaction
    params[:person].merge(
      person: current_person,
      telephones_attributes: params[:person][:telephones_attributes]&.values
    )
  end

  def render_edit_view
    if @current_step
      STEPS[@current_step][:before_render]&.call(current_person)

      render template: "registration_wizards/#{@current_step}_step"
    else
      redirect_to after_registration_path
    end
  end

  def set_current_step
    @current_step = Person::RegistrationStep.next(current_person.completed_registration_step)
  end

  def after_registration_path
    root_path
  end
end
