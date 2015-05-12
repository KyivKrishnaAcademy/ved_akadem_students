namespace :academic do
  desc 'Export data for students cards'
  task export_students_for_cards: :environment do
    PROGRESS_ELEMENT = '.'
    BASE_DIR         = Rails.root.join 'tmp'
    HEADER           = %w(ФИО_для_билета ФИО_для_QR Номер Группа Телефон Email Фото)

    def name_for_card(student)
      return student.spiritual_name if student.spiritual_name.present?

      "#{student.surname.titleize} #{student.name}#{student.middle_name.present? ? ' ' << student.middle_name : ''}"
    end

    def card_id(student)
      current_year = Date.current.year
      student_id   = '%06d' % student.id

      if (8..12).include?(Date.current.month)
        "#{current_year.to_s.last(2)}-#{current_year.next.to_s.last(2)}-#{student_id}"
      else
        "#{current_year.pred.to_s.last(2)}-#{current_year.to_s.last(2)}-#{student_id}"
      end
    end

    def email(email)
      email unless email =~ /(example\.com)|(students.veda-kiev.org.ua)/
    end

    def copy_photo(student, card_number, photo_dir)
      new_file_path = if student.photo.standart.file.present?
                        photo_dir.join "#{card_number}.#{student.photo.standart.file.extension}"
                      end

      return unless new_file_path.present?

      FileUtils.copy_file(Pathname.new(student.photo.standart.file.path), new_file_path)

      new_file_path
    end

    puts 'Exporting students data...'

    AcademicGroup.all.each do |group|
      next if group.active_students.none?

      puts group.group_name

      group_dir = BASE_DIR.join "student_cards_data/#{group.group_name}"
      photo_dir = group_dir.join 'photo'

      photo_dir.mkpath

      xlsx = Axlsx::Package.new

      xlsx.workbook.add_worksheet(name: group.group_name) do |sheet|
        sheet.add_row HEADER

        group.active_students.each do |student|
          card_number = card_id(student)
          photo_file  = copy_photo(student, card_number, photo_dir)

          sheet.add_row([
                          name_for_card(student),
                          student.complex_name,
                          card_number,
                          group.group_name,
                          student.telephones.first.phone,
                          email(student.email),
                          photo_file.present? ? photo_file.basename : nil
                        ])

          print PROGRESS_ELEMENT
        end
      end

      xlsx.serialize(group_dir.join("#{group.group_name}.xlsx"))
    end

    puts "\nDone!"
  end
end
