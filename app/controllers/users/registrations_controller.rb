# rubocop:disable Metrics/AbcSize
# since it is modified version of the Devise::RegistrationsController

module Users
  class RegistrationsController < Devise::RegistrationsController
    include CropDirectable

    STEP_INTERACTIONS = {
      'sign_up' => Active::PeopleRegistration::SignUpStepInteraction,
      'agreement' => Active::PeopleRegistration::AgreementStepInteraction,
      'identification' => Active::PeopleRegistration::IdentificationStepInteraction
    }

    def new
      build_resource({})

      respond_with(resource) do |format|
        format.html { render template: 'registration_wizard/sign_up_step' }
      end
    end

    def create
      self.resource = STEP_INTERACTIONS['sign_up'].run(params[:person])

      if resource.result&.persisted?
        self.resource = resource.result

        NotifyVerificationExpiredJob.perform_later(resource.id)

        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :success, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length

        respond_with(resource) do |format|
          format.html { render template: 'registration_wizard/sign_up_step' }
        end
      end
    end

    def edit
      render_edit_view
    end

    def update
      person = resource_get
      current_step = Person::RegistrationStep.next(person.completed_registration_step)
      self.resource = STEP_INTERACTIONS[current_step].run(params[:person].merge(person: person))

      if resource.result&.persisted?
        self.resource = resource.result

        NotifyVerificationExpiredJob.perform_later(resource.id)

        bypass_sign_in resource, scope: resource_name
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource

        respond_with(resource) do |format|
          format.html { render_edit_view }
        end
      end
    end

    private

    def render_edit_view
      current_step = Person::RegistrationStep.next(resource_get.completed_registration_step)

      render(current_step ? { template: "registration_wizard/#{current_step}_step" } : :edit)
    end

    def resource_get
      resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end

    def after_sign_up_path_for(resource)
      direct_to_crop(super(resource), resource)
    end

    def after_inactive_sign_up_path_for(resource)
      direct_to_crop(super(resource), resource)
    end

    def after_update_path_for(resource)
      direct_to_crop(super(resource), resource)
    end
  end
end

# rubocop:enable Metrics/AbcSize
