class StaticPagesController < ApplicationController
  before_action :authenticate_person!, only: :home

  def home
    @programs = Program.all
  end

  def about
  end
end
