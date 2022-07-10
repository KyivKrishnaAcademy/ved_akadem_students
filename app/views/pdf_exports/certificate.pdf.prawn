prawn_document(size: 'A4', page_layout: :landscape, template: @template_path) do |pdf|
  @blocks.each do |block|
    pdf.font(block[:font])
    pdf.text_box(block[:text], block[:text_box_options])
  end
end
