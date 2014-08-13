class PhotoUploader < BaseUploader
  version :standart do
    process resize_to_limit: [150, 200]
  end
end
