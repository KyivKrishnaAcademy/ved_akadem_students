class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  permissions 0600
  directory_permissions 0700

  process :optimize

  def store_dir
    subfolder = Rails.env.test? ? '/test' : ''

    Rails.root.join "uploads#{subfolder}", model.class.to_s.underscore, mounted_as.to_s
  end

  def cache_dir
    Rails.root.join 'tmp/uploads/cache'
  end

  def filename
    "#{secure_token}.jpg" if original_filename.present?
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/#{model.class.to_s.underscore}/" +
                                                  [version_name, 'default.png'].compact.join('_'))
  end

  def extension_white_list
     %w(jpg jpeg gif png)
  end

  private

  def optimize(quality_percent='80')
    manipulate! do |img|
      img.strip

      img.format('jpg') do |c|
        c.quality(quality_percent)
        c.depth '8'
        c.interlace 'plane'
      end

      img
    end
  end

  def crop
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i

        img.crop("#{w}x#{h}+#{x}+#{y}")

        img
      end
    end
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"

    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end
