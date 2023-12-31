class LocalesController < ApplicationController
  skip_before_action :authenticate_person!
  skip_before_action :ensure_registration_complete

  def toggle
    locale = I18n.locale == :ru ? :uk : :ru

    if current_person.present?
      current_person.update_column(:locale, locale)
    else
      session[:locale] = locale
    end

    redirect_back fallback_location: root_path
  end
end
