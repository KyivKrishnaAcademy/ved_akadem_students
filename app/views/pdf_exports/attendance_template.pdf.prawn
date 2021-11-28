prawn_document do |pdf|
  pdf.font("#{Rails.root}/vendor/fonts/DejaVuSans.ttf") do
    empty_rows_count = 7

    empty_rows = [{ content: nil, width: 40 }] * empty_rows_count
    date_rows  = empty_rows.map { |row| row.merge(height: 75)}
    sub_header = pdf.make_table([[{ content: 'Дата/предмет', colspan: empty_rows_count}], date_rows])
    header     = [['№', 'Студент', { content: sub_header, colspan: empty_rows_count}]]

    data = @academic_group.active_students.each_with_index.map do |person, index|
      [{ content: index.next.to_s, width: 25 }, { content: complex_name(person, short: true), width: 200 }] + empty_rows
    end

    pdf.text @academic_group.title

    pdf.table(header + data, header: true)

    string  = 'страница <page> из <total>'
    options = { at: [pdf.bounds.right - 150, pdf.bounds.top],
                width: 150,
                align: :right,
                color: '000000' }

    pdf.number_pages string, options
  end
end
