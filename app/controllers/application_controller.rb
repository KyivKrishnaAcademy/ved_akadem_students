class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_filter :enable_http_auth, if: :use_http_auth?
  before_filter :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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
    flash[:danger] = t('not_authorized')

    redirect_to(request.referrer || root_path)
  end

  def pundit_user
    current_person
  end
end
