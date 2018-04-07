class LocalesController < ApplicationController
  skip_before_action :authenticate_person!

  def toggle
    locale = I18n.locale == :ru ? :uk : :ru

    if current_person.present?
      current_person.update_column(:locale, locale) # rubocop:disable Rails/SkipsModelValidations
    else
      session[:locale] = locale
    end

    redirect_back fallback_location: root_path
  end
end
