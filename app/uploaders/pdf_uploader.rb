class PdfUploader < BaseUploader
  def extension_allowlist
    %w[pdf]
  end

  private

  def default_extension
    'pdf'
  end
end
