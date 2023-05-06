class RegistrationWizardsController < ApplicationController
  skip_before_action :ensure_registration_complete

  before_action :set_form_resource, only: %i[edit update]

  STEPS = {
    'agreement' => {
      template: 'registration_wizards/agreement_step',
      form: RegistrationWizard::AgreementForm
    },
    'identification' => {
      template: 'registration_wizards/identification_step',
      form: RegistrationWizard::IdentificationForm
    },
    'telephones' => {
      template: 'registration_wizards/telephones_step',
      form: RegistrationWizard::TelephonesForm
    }
  }

  def edit
    render_edit_view
  end

  def update
    @form_resource.assign_attributes(form_params)

    if @form_resource.save
      NotifyVerificationExpiredJob.perform_later(current_person.id)

      redirect_to after_registration_path
    else
      render_edit_view
    end
  end

  private

  def set_form_resource
    @form_resource = step_config[:form].new(person: current_person)
  end

  def form_params
    params.require(:registration_wizard).permit!
  end

  def render_edit_view
    if step_config
      step_config[:before_render]&.call(current_person)

      render step_config[:template]
    else
      redirect_to after_registration_path
    end
  end

  def current_step
    @current_step ||= Person::RegistrationStep.next(current_person.completed_registration_step)
  end

  def step_config
    @step_config ||= STEPS[current_step]
  end

  def after_registration_path
    root_path
  end
end
