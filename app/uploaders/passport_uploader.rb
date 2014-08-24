class PassportUploader < BaseUploader
  process resize_to_limit: [500, 500]
end
