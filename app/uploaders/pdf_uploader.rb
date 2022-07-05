class PDFUploader < BaseUploader
  def extension_white_list
    %w[pdf]
  end

  private

  def default_extension
    'pdf'
  end
end
