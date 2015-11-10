class CertificateTemplateUploader < BaseUploader
  before :cache, :capture_size
  before :retrieve_from_cache, :capture_size

  version :preview do
    process resize_to_limit: [1000, 800]
  end

  def extension_white_list
    %w(png)
  end

  private

  def capture_size(new_file)
    return if new_file.blank? || version_name.present?

    model.background_width, model.background_height = get_file_size(new_file)
  end

  def default_extension
    'png'
  end
end
