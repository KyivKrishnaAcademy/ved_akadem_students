class PhotoUploader < BaseImageUploader
  before :cache, :capture_size
  before :retrieve_from_cache, :capture_size

  process :auto_orient
  process :optimize

  process resize_to_limit: [500, 500]

  version :standart do
    process :crop
    process resize_to_limit: [150, 200]
  end

  version :thumb, from_version: :standart do
    process resize_to_limit: [24, 32]
  end

  private

  def capture_size(new_file)
    return unless new_file.present? && model.photo_upload_width.nil?

    model.photo_upload_width, model.photo_upload_height = get_image_size(new_file)
  end
end
