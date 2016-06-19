module Ui
  class CertificatesController < Ui::BaseController
    after_action :verify_authorized

    def create
      certificate = Certificate.new(
        params.require(:certificate).permit(:student_profile_id, :assigned_cert_template_id)
      )

      authorize certificate, :ui_create?

      if certificate.save
        render json: { success: true }
      else
        render json: { success: false, errors: certificate.errors.full_messages }, status: 422
      end
    end
  end
end
