class LocalesController < ApplicationController
  respond_to :js, only: :togge

  def toggle
    session[:locale] = session[:locale] == :ru || session[:locale].blank? ? :uk : :ru
  end
end
