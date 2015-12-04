class PassportUploader < BaseUploader
  process :optimize

  process resize_to_limit: [500, 500]
end
