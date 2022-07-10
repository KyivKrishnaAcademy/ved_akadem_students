class BaseImageUploader < BaseUploader
  include CarrierWave::MiniMagick

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

  def get_image_size(file)
    path = file.is_a?(String) ? Rails.root.join('tmp/uploads/cache', file) : file.path

    `identify -format "%wx %h" #{path}`.split(/x/).map(&:to_i)
  end
end
