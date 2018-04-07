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

  private

  def set_academic_group
    @academic_group = AcademicGroup.find(params[:id])
  end
end
