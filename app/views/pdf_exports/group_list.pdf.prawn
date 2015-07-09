prawn_document do |pdf|
  pdf.font("#{Rails.root}/vendor/fonts/DejaVuSans.ttf") do
    pdf.text @academic_group.title

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.table(
        @academic_group.active_students.each_with_index.map do |person, index|
          image = if person.photo.thumb.path.present?
                    person.photo.thumb.path
                  else
                    Rails.root.join 'app/assets/images/fallback/person/thumb_default.png'
                  end

          [index.next, { image: image }, complex_name(person, true)]
        end
      )
    end

    string  = 'страница <page> из <total>'
    options = { at: [pdf.bounds.right - 150, pdf.bounds.top],
                width: 150,
                align: :right,
                color: '000000' }

    pdf.number_pages string, options
  end
end
