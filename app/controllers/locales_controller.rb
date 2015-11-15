class LocalesController < ApplicationController
  skip_before_action :authenticate_person!, :set_locale

  def toggle
    session[:locale] = I18n.locale.to_sym == :ru ? :uk : :ru

    redirect_to :back
  end
end
