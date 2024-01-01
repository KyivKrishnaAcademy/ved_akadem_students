class SignatureUploader < BaseImageUploader
  def extension_white_list
    %w[png]
  end

  private

  def default_extension
    'png'
  end
end
