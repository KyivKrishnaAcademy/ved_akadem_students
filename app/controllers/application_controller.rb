class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :enable_http_auth, if: :use_http_auth?
  before_filter :set_locale

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
end
