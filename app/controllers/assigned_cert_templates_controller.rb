class AssignedCertTemplatesController < ApplicationController
  after_action :verify_authorized, :verify_policy_scoped

  def create
    assigned_cert_template = AssignedCertTemplate.new(
      params.permit(:academic_group_id, :certificate_template_id)
    )

    authorize assigned_cert_template

    assigned_cert_template.save

    redirect_to academic_group_path(params[:academic_group_id])
  end
end
