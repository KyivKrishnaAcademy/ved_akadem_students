class StudyApplicationsController < ApplicationController
  include StudyApplicationable

  respond_to :js

  after_action :verify_authorized

  def create
    @study_application = StudyApplication.find_or_initialize_by(person_id: permitted_params[:person_id])
    @study_application.program_id = permitted_params[:program_id]

    common_handle(@study_application, :create) do |study_applicaiton|
      study_applicaiton.person.add_application_questionnaires

      ProgrammApplicationsMailer.submitted(study_applicaiton.person, study_applicaiton.program).deliver_later
    end
  end

  def destroy
    @study_application = StudyApplication.find(params[:id])

    common_handle(@study_application, :destroy)
  end

  private

  def common_handle(study_application, method)
    authorize study_application

    operation_result = method == :create ? study_application.save : study_application.destroy.destroyed?

    if operation_result
      yield study_application if block_given?

      preset_applications_variables(study_application.person)

      @is_links_in_pending_docs = ActiveModel::Type::Boolean.new.cast(permitted_params[:is_links_in_pending_docs])

      render partial: 'common'
    else
      render nothing: true, status: :not_implemented
    end
  end

  def permitted_params
    params.require(:study_application).permit(:person_id, :program_id, :is_links_in_pending_docs)
  end
end
