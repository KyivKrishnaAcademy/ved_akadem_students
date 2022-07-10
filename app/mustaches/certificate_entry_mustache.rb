class CertificateEntryMustache < Mustache
  def initialize(certificate, options = {})
    @certificate = certificate
    @person = certificate.student_profile.person

    super(options)
  end

  def serial
    @certificate.serial_id
  end

  def issued_date
    @certificate.issued_date.strftime('%d.%m.%Y')
  end

  def male?
    @person.gender
  end

  def female?
    !male?
  end

  def name
    @person.diploma_name.presence || "#{@person.surname} #{@person.name}"
  end

  def diploma_name_present?
    @person.diploma_name.present?
  end
end
