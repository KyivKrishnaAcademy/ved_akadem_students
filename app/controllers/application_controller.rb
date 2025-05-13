class ApplicationController < ActionController::Base
  include Pundit::Authorization

  protect_from_forgery with: :exception, unless: :api?

  before_action :set_paper_trail_whodunnit, :set_raven_context
  before_action :set_locale, :authenticate_person!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_person # Making the method available in views and controllers

  private

  def current_person
    @current_person ||= warden.authenticate(scope: :person)
  end

  def set_locale
    I18n.locale = current_person.present? ? current_person.locale : session[:locale] || :uk
  end

  def user_not_authorized
    flash[:alert] = t('not_authorized')
    redirect_to(request.referer || root_path)
  end

  def pundit_user
    current_person
  end

  def user_for_paper_trail
    current_person.present? ? current_person.id : :anonymous
  end

  def respond_with_interaction(klass, resource = nil)
    render json: klass.new(user: current_person, params: params, resource: resource)
  end

  def api?
    self.class < Api::V1::BaseController
  end

  def set_raven_context
    Sentry.set_user(id: user_for_paper_trail)
    Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
  end
end
