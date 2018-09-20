module Users
  class RegistrationsController < Devise::RegistrationsController
    include CropDirectable

    before_action :sanitize_sign_up, only: :create
    before_action :sanitize_account_update, only: :update

    PERMITTED_PARAMS = [
      :name, :surname, :spiritual_name, :middle_name, :gender, :photo, :photo_cache, :diksha_guru,
      :birthday, :education, :work, :emergency_contact, :marital_status,
      :friends_to_be_with, telephones_attributes: %i[id phone _destroy]
    ].freeze

    def new
      super do |resource|
        resource.telephones.build
      end
    end

    def create
      super do |resource|
        NotifyVerificationExpiredJob.perform_later(resource.id) if resource.persisted?
      end
    end

    def update
      user_before_save = resource

      self.resource = resource_get
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      resource_updated = update_resource(resource, account_update_params)

      if resource_updated
        unverify_user(user_before_save)

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

    def unverify_user(user_before_save)
      return unless resource.verified?

      new_params = account_update_params.dup

      new_params.delete(:current_password)
      new_params.delete(:telephones_attributes)

      user_before_save.assign_attributes(new_params)

      return if user_before_save.changed_attributes.keys.reject { |k| k =~ /password/ }.none?

      resource.update(verified: false)

      NotifyVerificationExpiredJob.perform_later(resource.id)
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
  end
end
