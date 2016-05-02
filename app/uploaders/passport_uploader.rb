class PassportUploader < BaseUploader
  process :auto_orient
  process :optimize

  process resize_to_limit: [500, 500]
end
