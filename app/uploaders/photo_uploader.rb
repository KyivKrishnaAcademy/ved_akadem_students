class PhotoUploader < BaseUploader
  before :cache, :capture_size_before_cache

  version :standart do
    process resize_to_limit: [150, 200]
  end

  private

  def capture_size_before_cache(new_file)
    if model.photo_upload_width.nil? || model.photo_upload_height.nil?
      model.photo_upload_width, model.photo_upload_height = `identify -format "%wx %h" #{new_file.path}`.split(/x/).map { |dim| dim.to_i }
    end
  end
end
