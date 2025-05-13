class TtfUploader < BaseUploader
  def extension_allowlist
    %w[ttf]
  end

  private

  def default_extension
    'ttf'
  end
end
