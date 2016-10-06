module Users
  class RegistrationsController < Devise::RegistrationsController
    include CropDirectable

    before_action :sanitize_sign_up, only: :create
    before_action :sanitize_account_update, only: :update

    PERMITTED_PARAMS = [
      :name, :surname, :spiritual_name, :middle_name, :gender, :photo, :photo_cache, :diksha_guru,
      :birthday, :education, :work, :emergency_contact, :passport, :passport_cache, :marital_status,
      :friends_to_be_with, telephones_attributes: [:id, :phone, :_destroy]
    ].freeze

    def new
      super do |resource|
        resource.telephones.build
      end
    end

    private

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
