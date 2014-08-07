class LocalesController < ApplicationController
  def toggle
    session[:locale] = session[:locale] == :ru ? :uk : :ru

    redirect_to :back
  end
end
