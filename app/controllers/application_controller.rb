class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception, unless: :api?

  before_action :set_paper_trail_whodunnit, :set_raven_context
  before_action :set_locale, :authenticate_person!, :ensure_registration_complete, unless: :devise_token_auth?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_locale
    I18n.locale = current_person.present? ? current_person.locale : session[:locale] || :uk
  end

  def user_not_authorized
    flash[:danger] = t('not_authorized')

    redirect_to((request.referer || root_path), status: :see_other)
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
    devise_token_auth? || self.class < Api::V1::BaseController
  end

  def devise_token_auth?
    self.class < DeviseTokenAuth::ApplicationController
  end

  def set_raven_context
    Raven.user_context(id: user_for_paper_trail)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def ensure_registration_complete
    return unless current_person
    return if Person::RegistrationStep.last?(current_person.completed_registration_step)
    return if self.class < DeviseController

    redirect_to(edit_person_registration_path(current_person))
  end
end
