class CropsController < ApplicationController
  before_action :authenticate_person!

  after_action :verify_authorized
  before_action :set_person

  def crop_image; end

  def update_image
    if @person.crop_photo(PersonParams.filter(params))
      redirect_to(session[:after_crop_path] || root_path)
    else
      flash[:danger] = I18n.t('crops.error')

      render action: :crop_image
    end
  end

  private

  def set_person
    @person = Person.find(params[:id])

    authorize @person
  end

  class PersonParams
    def self.filter(params)
      params.require(:person).permit(:crop_x, :crop_y, :crop_w, :crop_h)
    end
  end
end
