module CropDirectable
  private

  def direct_to_crop(default, resource)
    if params[:person][:photo].present? || params[:person][:photo_cache].present?
      session[:after_crop_path] = default

      crop_image_path(resource.id)
    else
      default
    end
  end
end
