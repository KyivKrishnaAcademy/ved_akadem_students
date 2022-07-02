class TTFUploader < BaseUploader
  def extension_white_list
    %w[ttf]
  end

  private

  def default_extension
    'ttf'
  end
end
