prawn_document(size: 'A4', page_layout: :landscape, template: @template_path) do |pdf|
  @blocks.each do |block|
    case block[:type]
    when :text_block
      pdf.font(block[:font])
      pdf.text_box(block[:text], block[:text_box_options])
    when :image_block
      pdf.rotate(block[:angle], origin: block[:rotation_origin]) do
        pdf.image(block[:file_path], at: block[:at], scale: block[:scale])
      end
    end
  end
end
