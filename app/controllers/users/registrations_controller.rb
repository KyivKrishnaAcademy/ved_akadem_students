module Users
  class RegistrationsController < Devise::RegistrationsController
    include CropDirectable

    before_action :sanitize_sign_up, only: :create
    before_action :sanitize_account_update, only: :update

    PERMITTED_PARAMS = [
      :name, :surname, :middle_name, :gender, :photo, :photo_cache, :diploma_name,
      :birthday, { telephones_attributes: %i[id phone _destroy] }
    ].freeze

    def new
      return if farewell_redirect

      super do |resource|
        resource.telephones.build
      end
    end

    def create
      return if farewell_redirect

      super do |resource|
        NotifyVerificationExpiredJob.perform_later(resource.id) if resource.persisted?
      end
    end

    def update
      return if farewell_redirect

      self.resource = resource_get
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      resource_updated = update_resource(resource, account_update_params)

      if resource_updated
        NotifyVerificationExpiredJob.perform_later(resource.id)

        if is_flashing_format?
          flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
            :update_needs_confirmation
          else
            :updated
          end

          set_flash_message :notice, flash_key
        end
        bypass_sign_in resource, scope: resource_name
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        respond_with resource
      end
    end

    private

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

    def sanitize_sign_up
      devise_parameter_sanitizer.permit(:sign_up, keys: [:privacy_agreement].concat(PERMITTED_PARAMS))
    end

    def sanitize_account_update
      if password_provided?
        devise_parameter_sanitizer.permit(:account_update, keys: PERMITTED_PARAMS)
      else
        params[:person].delete(:password)
        params[:person].delete(:password_confirmation)
        params[:person][:skip_password_validation] = true

        devise_parameter_sanitizer.permit(:account_update, keys: [:skip_password_validation].concat(PERMITTED_PARAMS))
      end
    end

    def password_provided?
      params[:person][:password].present? || params[:person][:password_confirmation].present?
    end

    def farewell_redirect
      return unless Rails.application.secrets.farewell

      redirect_back fallback_location: root_path,
                    flash: { danger: 'Реєструйтеся на новому порталі будь ласка' }

      true
    end
  end
end
