# rubocop:disable Metrics/AbcSize
# since it is modified version of the Devise::RegistrationsController

module Users
  class RegistrationsController < Devise::RegistrationsController
    include CropDirectable

    def new
      @form_resource = RegistrationWizard::SignUpForm.new

      respond_with(resource) do |format|
        format.html { render template: 'registration_wizards/sign_up_step' }
      end
    end

    def create
      form = RegistrationWizard::SignUpForm.new

      form.assign_attributes(params.require(:registration_wizard).permit!)

      if form.save
        self.resource = form.person

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
        @form_resource = form

        respond_with(resource) do |format|
          format.html { render template: 'registration_wizards/sign_up_step' }
        end
      end
    end

    def update
      interaction = Active::PersonEdit::ChangePasswordInteraction.run(
        params[:person].merge(person: resource_get)
      )

      if interaction.errors.none?
        self.resource = interaction.result

        NotifyVerificationExpiredJob.perform_later(resource.id)

        if is_flashing_format?
          set_flash_message :notice, :password_updated
        end

        bypass_sign_in resource, scope: resource_name
        respond_with resource, location: after_update_path_for(resource)
      else
        self.resource = interaction

        clean_up_passwords resource
        respond_with resource
      end
    end

    private

    def resource_get
      resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end
  end
end

# rubocop:enable Metrics/AbcSize
