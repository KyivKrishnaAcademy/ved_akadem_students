class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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

  def extension_white_list
    %w[jpg jpeg gif png]
  end

  private

  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  def default_extension
    'jpg'
  end

  def optimize(quality_percent = '80')
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

  def crop(crop_w = 150, crop_h = 200)
    x, y, w, h = crop_params(crop_w, crop_h)

    manipulate! do |img|
      img.crop("#{w}x#{h}+#{x}+#{y}")

      img
    end
  end

  def crop_params(crop_w, crop_h)
    if model.crop_x.present?
      [model.crop_x.to_i, model.crop_y.to_i, model.crop_w.to_i, model.crop_h.to_i]
    else
      [0, 0, crop_w, crop_h]
    end
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"

    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end

  def get_file_size(file)
    path = file.is_a?(String) ? Rails.root.join('tmp/uploads/cache', file) : file.path

    `identify -format "%wx %h" #{path}`.split(/x/).map(&:to_i)
  end
end
