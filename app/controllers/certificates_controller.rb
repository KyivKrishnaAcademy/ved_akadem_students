class CertificatesController < HtmlRespondableController
  before_action :authenticate_person!

  after_action :verify_authorized

  def index
    @certificate_template = CertificateTemplate.find(params[:certificate_template_id])

    @certificates =
      Certificate
        .where(certificate_template_id: params[:certificate_template_id])
        .includes(:academic_group, student_profile: :person)
        .order('people.complex_name ASC')
        .page(params[:page])

    authorize @certificates

    respond_with(@certificates)
  end
end
