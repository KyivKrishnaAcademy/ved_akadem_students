class StudyApplicationsController < ApplicationController
  include StudyApplicationable

  respond_to :js

  after_action :verify_authorized

  def create
    @study_application = StudyApplication.new(study_application_params)

    common_handle(@study_application, :create) do |study_applicaiton|
      study_applicaiton.person.add_application_questionnaires
    end
  end

  def destroy
    @study_application = StudyApplication.find(params[:id])

    common_handle(@study_application, :destroy) do |study_applicaiton|
      study_applicaiton.person.remove_application_questionnaires(study_applicaiton)
    end
  end

  private

  def common_handle(study_application, method)
    authorize study_application

    operation_result = method == :create ? study_application.save : study_application.destroy.destroyed?

    if operation_result
      yield study_application

      preset_applications_variables(study_application.person)

      render partial: 'common'
    else
      render nothing: true, status: 501
    end
  end

  def study_application_params
    params.require(:study_application).permit(:person_id, :program_id)
  end
end
