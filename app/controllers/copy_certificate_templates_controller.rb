class CopyCertificateTemplatesController < HtmlRespondableController
  before_action :authenticate_person!

  def create
    orig_template = CertificateTemplate.find(params[:certificate_template_id])
    new_template = CertificateTemplate.new(orig_template.attributes.slice('title', 'institution_id', 'program_type'))

    authorize new_template

    new_template.title = "Copy of #{new_template.title}"
    new_template.file = orig_template.file

    ActiveRecord::Base.transaction do
      new_template.save

      orig_template.certificate_template_entries.each do |entry|
        duplicate_object(entry, new_template.id)
      end

      orig_template.certificate_template_images.each do |image|
        duplicate_object(image, new_template.id)
      end
    end

    respond_with(
      new_template,
      location: -> { edit_certificate_template_path(new_template) }
    )
  end

  private

  def duplicate_object(related_object, new_template_id)
    dup = related_object.dup
    dup.certificate_template_id = new_template_id
    dup.save
  end
end
