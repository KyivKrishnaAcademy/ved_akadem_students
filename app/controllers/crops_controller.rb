class CropsController < ApplicationController
  before_action :authenticate_person!

  after_action :verify_authorized

  def crop_image
    @person = Person.find(params[:id])

    authorize @person
  end

  def update_image
    @person = Person.find(params[:id])

    authorize @person

    if @person.crop_photo(PersonParams.filter(params))
      path = session[:after_crop_path].present? ? session[:after_crop_path] : root_path

      redirect_to path, flash: { success: 'Image was successfully cropped.' }
    else
      flash[:error] = 'Image was not cropped.'

      render action: :crop_image
    end
  end

  private

  class PersonParams
    def self.filter params
      params.require(:person).permit(:crop_x, :crop_y, :crop_w, :crop_h)
    end
  end
end
