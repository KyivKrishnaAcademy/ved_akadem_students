namespace :academic do
  desc 'Creates the certificates'
  task import_certificates: :environment do
    ActiveRecord::Base.logger = nil

    path = Rails.root.join('tmp', 'certificates_to_import.csv')

    unless path.exist?
      puts "#{path} does not exist"

      next
    end

    existed_count = 0
    added_count = 0
    error_count = 0

    File.foreach(path) do |entry|
      errors = []
      serial_id, issued_date, template_id = entry.chomp.split(',')
      course, group_serial, _, person_id = serial_id.split('-')
      group_title = "#{course}-#{group_serial}"

      group = AcademicGroup.find_by(title: group_title)
      student_profile = StudentProfile.find_by(person_id: person_id)
      certificate_template = CertificateTemplate.find_by(id: template_id)

      errors << "AcademicGroup #{group_title} not found" unless group
      errors << "StudentProfile for Person #{person_id} not found" unless student_profile
      errors << "CertificateTemplate #{template_id} not found" unless certificate_template

      if errors.size > 0
        error_count += 1

        puts "\n#{serial_id}: #{errors.join(', ')}"
      else
        certificate_params = {
          academic_group_id: group.id,
          certificate_template_id: certificate_template.id,
          student_profile_id: student_profile.id,
          serial_id: serial_id
        }

        begin
          if Certificate.find_by(certificate_params)
            existed_count += 1
          else
            Certificate.create!(certificate_params.merge({ issued_date: issued_date }))

            added_count += 1
          end

          print '.'
        rescue StandardError => e
          error_count += 1

          puts "\n#{e.message}"
        end
      end
    end

    puts "\n\nAlready exist: #{existed_count}\nAdded: #{added_count}\nFailed: #{error_count}\nDone."
  end
end
