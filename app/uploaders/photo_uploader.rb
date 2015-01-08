class PhotoUploader < BaseUploader
  before :cache, :capture_size
  before :retrieve_from_cache, :capture_size

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
    if new_file.present? && model.photo_upload_width.nil?
      path = new_file.is_a?(String) ? Rails.root.join('tmp/uploads/cache', new_file) : new_file.path

      model.photo_upload_width, model.photo_upload_height = `identify -format "%wx %h" #{path}`.split(/x/).map { |dim| dim.to_i }
    end
  end
end
