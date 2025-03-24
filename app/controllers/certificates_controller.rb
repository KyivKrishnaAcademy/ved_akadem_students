class CertificatesController < HtmlRespondableController
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

    return redirect_with_alert(t('certificates.destroy.not_found')) if @certificate.nil?

    message_key = @certificate.destroy ? 'certificates.destroy.success' : 'certificates.destroy.failure'
    redirect_with_notice(t(message_key))
  end

  private

  def redirect_with_alert(message)
    redirect_to(request.referer || certificate_templates_path, alert: message)
  end

  def redirect_with_notice(message)
    redirect_to(request.referer || certificate_templates_path, notice: message)
  end
end
