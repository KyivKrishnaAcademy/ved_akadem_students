namespace :academic do
  desc 'Export data to engage persons in service'
  task export_for_service: :environment do
    PROGRESS_ELEMENT = '.'
    BASE_DIR         = Rails.root.join 'tmp'
    HEADER           = %w[ФИО группы телефоны работа образование]

    def name_for_card(person)
      return person.diploma_name if person.diploma_name.present?

      "#{person.surname.mb_chars.upcase} #{person.name}#{person.middle_name.present? ? ' ' << person.middle_name : ''}"
    end

    puts 'Exporting persons data...'

    xlsx = Axlsx::Package.new

    xlsx.workbook.add_worksheet(name: 'Все') do |sheet|
      sheet.add_row HEADER

      Person.all.each do |person|
        sheet.add_row([
                        name_for_card(person),
                        person.student_profile.try(:academic_groups).try(:map, &:title).try(:join, ', '),
                        person.telephones.map(&:phone).join(', '),
                        person.work,
                        person.education
                      ])

        print PROGRESS_ELEMENT
      end
    end

    puts

    xlsx.serialize(BASE_DIR.join('export_for_service.xlsx'))

    puts "\nDone!"
  end
end
