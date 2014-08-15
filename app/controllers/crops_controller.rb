class CropsController < ApplicationController
  before_action :authenticate_person!

  after_action :verify_authorized

  def crop_image
    @person = Person.find(params[:id])

    authorize @person
  end
end
