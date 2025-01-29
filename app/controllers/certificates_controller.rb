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

  def destroy
    @certificate = Certificate.find_by(id: params[:id], certificate_template_id: params[:certificate_template_id])
    
    authorize @certificate || Certificate.new
    
    if @certificate.nil?
      redirect_to (request.referer || certificate_templates_path), alert: t('certificates.destroy.not_found') and return
    end
  
    if @certificate.destroy
      redirect_to (request.referer || certificate_templates_path), notice: t('certificates.destroy.success')
    else
      redirect_to (request.referer || certificate_templates_path), alert: t('certificates.destroy.failure')
    end
  end
end
