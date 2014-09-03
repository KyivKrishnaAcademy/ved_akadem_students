class StaticPagesController < ApplicationController
  before_action :authenticate_person!, only: :home

  def home
  end

  def about
  end
end
