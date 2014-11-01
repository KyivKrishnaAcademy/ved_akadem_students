class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_filter :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_locale
    I18n.locale = session[:locale] if session[:locale].present?
  end

  def user_not_authorized
    flash[:danger] = t('not_authorized')

    redirect_to(request.referrer || root_path)
  end

  def pundit_user
    current_person
  end
end
