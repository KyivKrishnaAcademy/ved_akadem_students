class PdfExportsController < ApplicationController
  respond_to :pdf

  skip_before_action :set_locale

  after_action :verify_authorized

  def group_list
    @academic_group = AcademicGroup.find(params[:id])

    authorize @academic_group, :group_list_pdf?
  end
end
