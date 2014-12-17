class LocalesController < ApplicationController
  skip_before_action :authenticate_person!

  def toggle
    session[:locale] = session[:locale] == :ru ? :uk : :ru

    redirect_to :back
  end
end
