class PdfExportsController < ApplicationController
  respond_to :pdf

  skip_before_action :set_locale

  before_action :set_academic_group, only: %i[group_list attendance_template]

  after_action :verify_authorized

  def group_list
    authorize @academic_group, :group_list_pdf?
  end

  def attendance_template
    authorize @academic_group, :attendance_template_pdf?
  end

  def certificate_template_preview
    certificate_template = CertificateTemplate.find(params[:id])

    authorize certificate_template, :edit?

    student_profile = StudentProfile.new(person: current_person)

    certificate = Certificate.new(
      student_profile: student_profile,
      serial_id: SecureRandom.uuid,
      issued_date: Date.yesterday
    )

    prepare_certificate_data(certificate, certificate_template)

    render 'certificate'
  end

  def certificate
    certificate = Certificate.find_by!(serial_id: params[:serial_id])

    authorize certificate, :show?

    certificate_template = certificate.certificate_template

    prepare_certificate_data(certificate, certificate_template)
  end

  private

  def set_academic_group
    @academic_group = AcademicGroup.find(params[:id])
  end

  def prepare_certificate_data(certificate, certificate_template)
    mustache = CertificateEntryMustache.new(certificate)
    @template_path = certificate_template.file.file.path

    @blocks = certificate_template.certificate_template_entries.map do |entry|
      {
        text: mustache.render(entry.template),
        font: entry.certificate_template_font.file.file.path,
        text_box_options: {
          character_spacing: entry.character_spacing,
          size: entry.font_size,
          at: [entry.x, entry.y],
          align: entry.align.to_sym
        }
      }
    end
  end
end
