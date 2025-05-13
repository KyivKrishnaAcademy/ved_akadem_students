class BaseUploader < CarrierWave::Uploader::Base
  storage :file
  permissions 0o0604

  # 0o0655 breaks Travis tests
  directory_permissions 0o0701

  def store_dir
    subfolder = Rails.env.test? ? '/test' : ''

    Rails.root.join "uploads#{subfolder}", model.class.to_s.underscore, mounted_as.to_s
  end

  def cache_dir
    Rails.root.join 'tmp/uploads/cache'
  end

  def filename
    "#{secure_token}.#{default_extension}" if original_filename.present?
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/#{model.class.to_s.underscore}/" +
                                                  [version_name, 'default.png'].compact.join('_'))
  end

  def extension_allowlist
    raise 'Override me'
  end

  private

  def default_extension
    raise 'Override me'
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"

    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end
