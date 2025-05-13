class SignatureUploader < BaseImageUploader
  def extension_allowlist
    %w[png]
  end

  private

  def default_extension
    'png'
  end
end
