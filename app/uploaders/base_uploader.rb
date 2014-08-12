class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  permissions 0600
  directory_permissions 0700

  process convert: 'png'

  def store_dir
    subfolder = Rails.env.test? ? '/test' : ''

    Rails.root.join "uploads#{subfolder}", model.class.to_s.underscore, mounted_as.to_s
  end

  def cache_dir
    Rails.root.join 'tmp/uploads/cache'
  end

  def filename
    "#{model.id}.jpg"
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/#{model.class.to_s.underscore}/" +
                                                  [version_name, 'default.png'].compact.join('_'))
  end

  def extension_white_list
     %w(jpg jpeg gif png)
  end
end
