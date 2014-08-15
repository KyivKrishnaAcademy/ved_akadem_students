class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :remove_empty_password, only: :update

  private

  def configure_permitted_parameters
    permitted_params = [:name, :surname, :spiritual_name, :middle_name, :telephone, :gender,
                        :photo, :birthday, :edu_and_work, :emergency_contact]

    devise_parameter_sanitizer.for(:sign_up) << permitted_params
    devise_parameter_sanitizer.for(:account_update) << permitted_params << [:photo_cache]
  end

  def remove_empty_password
    if params[:person][:password].blank? && params[:person][:password_confirmation].blank?
      params[:person].delete(:password)
      params[:person].delete(:password_confirmation)
      params[:person].merge!(skip_password_validation: true)

      devise_parameter_sanitizer.for(:account_update) << [:skip_password_validation]
    end
  end
end
