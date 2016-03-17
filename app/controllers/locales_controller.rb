class LocalesController < ApplicationController
  skip_before_action :authenticate_person!

  def toggle
    locale = I18n.locale == :ru ? :uk : :ru

    if current_person.present?
      current_person.update(locale: locale)
    else
      session[:locale] = locale
    end

    redirect_to :back
  end
end
