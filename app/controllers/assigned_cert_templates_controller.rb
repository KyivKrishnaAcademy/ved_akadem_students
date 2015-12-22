class AssignedCertTemplatesController < ApplicationController
  after_action :verify_authorized

  def create
    assigned_cert_template = AssignedCertTemplate.new(
      params.require(:assigned_cert_template).permit(:academic_group_id, :certificate_template_id)
    )

    authorize assigned_cert_template

    assigned_cert_template.save

    redirect_to academic_group_path(params[:assigned_cert_template][:academic_group_id])
  end
end
