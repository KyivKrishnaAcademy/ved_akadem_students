class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :enable_http_auth, if: :use_http_auth?
  before_filter :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :surname, :spiritual_name, :middle_name, :telephone, :gender,
                                                 :photo, :birthday, :edu_and_work, :emergency_contact]
  end

  private

  def set_locale
    I18n.locale = session[:locale] if session[:locale].present?
  end

  def use_http_auth?
    Rails.env.production?
  end

  def enable_http_auth
    authenticate_or_request_with_http_basic('Application') do |name, password|
      name == 'ved_akadem' && password == 'secret123!'
    end
  end

  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'

    redirect_to(request.referrer || root_path)
  end

  def pundit_user
    current_person
  end
end
