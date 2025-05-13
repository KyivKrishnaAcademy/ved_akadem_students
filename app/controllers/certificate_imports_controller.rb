class CertificateImportsController < HtmlRespondableController
  before_action :authenticate_person!

  after_action :verify_authorized

  def new
    authorize CertificateImportsController
  end

  def create
    authorize CertificateImportsController

    file = permitted_params.to_h.fetch(:certificate_import, {}).fetch(:file, nil)

    if file.present?
      @result = ImportCertificatesService.call(file.read)
    else
      redirect_to new_certificate_import_path, alert: t('certificate_imports.new.file_is_not_present_alert')

    end
  end

  private

  def permitted_params
    params.permit(certificate_import: [:file])
  end
end
