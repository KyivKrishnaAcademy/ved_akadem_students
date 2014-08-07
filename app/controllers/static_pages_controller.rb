class StaticPagesController < ApplicationController
  def home
    redirect_to(controller: 'devise/sessions', action: :new) unless person_signed_in?
  end

  def about
  end
end
