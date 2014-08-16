class CropsController < ApplicationController
  before_action :authenticate_person!

  after_action :verify_authorized

  def crop_image
    @person = Person.find(params[:id])

    authorize @person
  end

  def update_image
    @person = policy_scope(Person).find(params[:id])

    authorize @person

    if @person.update_attributes(PersonParams.filter(params).merge(skip_password_validation: true))
      path = session[:after_crop_path].present? ? session[:after_crop_path] : root_path

      redirect_to path, flash: { success: 'Image was successfully cropped.' }
    else
      render action: :crop_image, flash: { success: 'Image was not cropped.' }
    end
  end

  private

  class PersonParams
    def self.filter params
      params.require(:person).permit(:crop_x, :crop_y, :crop_w, :crop_h)
    end
  end
end
