class PhotoUploader < BaseUploader
  before :cache, :capture_size_before_cache

  process resize_to_limit: [500, 500]

  version :standart do
    process :crop
    process resize_to_limit: [150, 200]
  end

  version :thumb, from_version: :standart do
    process resize_to_limit: [24, 32]
  end

  private

  def capture_size_before_cache(new_file)
    if model.photo_upload_width.nil? || model.photo_upload_height.nil?
      model.photo_upload_width, model.photo_upload_height = `identify -format "%wx %h" #{new_file.path}`.split(/x/).map { |dim| dim.to_i }
    end
  end
end
