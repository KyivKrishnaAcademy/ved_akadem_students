require 'csv'

class ImportCertificatesService
  PERSON_ID = 0
  TEMPLATE_ID = 1
  ISSUED_DATE_STR = 2
  GROUP_ID = 3
  SERIAL = 4
  FINAL_SCORE = 5

  def self.call(payload)
    result = []

    ::CSV.new(payload, converters: :all, skip_blanks: true).each do |row|
      result << process_pipes(row, [
                                method(:process_row),
                                method(:load_person),
                                method(:load_template),
                                method(:load_issued_date),
                                method(:load_group),
                                method(:load_serial),
                                method(:check_final_score),
                                method(:persist_certificate)
                              ])
    end

    result
  end

  private_class_method def self.process_row(row)
    {
      person_id: row[PERSON_ID],
      person: nil,
      student_profile_id: nil,
      person_error: nil,
      template_id: row[TEMPLATE_ID],
      template: nil,
      template_error: nil,
      issued_date_str: row[ISSUED_DATE_STR],
      issued_date: nil,
      group_id: row[GROUP_ID],
      group: nil,
      serial: row[SERIAL]&.force_encoding('UTF-8'),
      serial_error: nil,
      final_score: row[FINAL_SCORE],
      final_score_error: nil,
      certificate_persisted?: false,
      certificate_creation_details: nil
    }
  end

  private_class_method def self.load_person(data)
    person_id = data[:person_id]
    person = Person.find_by(id: person_id)

    if person.present?
      data[:person] = person
      data[:student_profile_id] = person.student_profile&.id || person.create_student_profile&.id
    else
      data[:person_error] = "Can not find person with ID #{person_id}"
    end

    data
  end

  private_class_method def self.load_template(data)
    template_id = data[:template_id]
    template = CertificateTemplate.find_by(id: template_id)

    if template.present?
      data[:template] = template
    else
      data[:template_error] = "Can not find template with ID #{template_id}"
    end

    data
  end

  private_class_method def self.load_issued_date(data)
    issued_date_str = data[:issued_date_str]

    issued_date = if issued_date_str.present?
      Date.parse(issued_date_str)
    else
      Time.zone.today
    end

    data[:issued_date] = issued_date

    data
  end

  private_class_method def self.load_group(data)
    group_id = data[:group_id]

    data[:group] = AcademicGroup.where(id: group_id).or(AcademicGroup.where(title: group_id)).first

    data
  end

  private_class_method def self.load_serial(data)
    return data if data[:serial].present?

    group, person, template = data.fetch_values(:group, :person, :template)

    if group.present? && person.present? && template.present?
      data[:serial] = "#{group.title}-#{template.id}-#{person.id}"
    else
      data[:serial_error] = 'Serial is not set and can not be autogenerated since Academic Group is missing also'
    end

    data
  end

  private_class_method def self.check_final_score(data)
    return data if data[:final_score].is_a?(Integer)

    data[:final_score] = nil

    if data[:template]&.is_final_score_required
      data[:final_score_error] = 'Final Score is required for this certificate template'
    end

    data
  end

  private_class_method def self.persist_certificate(data)
    errors = data.fetch_values(:person_error, :template_error, :serial_error, :final_score_error)

    return data if errors.any?(&:present?)

    serial_id = data[:serial]

    if Certificate.where(serial_id: serial_id).any?
      data[:certificate_persisted?] = true
      data[:certificate_creation_details] = "Certificate #{serial_id} already exists"

      return data
    end

    certificate = Certificate.create(
      serial_id: serial_id,
      academic_group_id: data[:group]&.id,
      certificate_template_id: data[:template].id,
      student_profile_id: data[:student_profile_id],
      issued_date: data[:issued_date],
      final_score: data[:final_score]
    )

    if certificate.persisted?
      data[:certificate_persisted?] = true
      data[:certificate_creation_details] = 'Certificate created'
    else
      data[:certificate_creation_details] = certificate.errors.full_messages.join(', ')
    end

    data
  end

  private_class_method def self.process_pipes(data, pipes)
    pipes.each do |pipe|
      data = pipe.call(data)
    end

    data
  end
end
