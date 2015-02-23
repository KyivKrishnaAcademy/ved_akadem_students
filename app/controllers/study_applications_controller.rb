class StudyApplicationsController < ApplicationController
  include StudyApplicationable

  respond_to :js

  after_action :verify_authorized

  def create
    @study_application = StudyApplication.new(study_application_params)

    authorize @study_application

    if @study_application.save
      @study_application.person.add_application_questionnaires

      preset_applications_variables(@study_application.person)

      render partial: 'common'
    else
      render nothing: true, status: 501
    end
  end
  #TODO DRY it
  def destroy
    @study_application = StudyApplication.find(params[:id])

    authorize @study_application

    if @study_application.destroy.destroyed?
      @study_application.person.remove_application_questionnaires(@study_application)

      preset_applications_variables(@study_application.person)

      render partial: 'common'
    else
      render nothing: true, status: 501
    end
  end

  private

  def study_application_params
    params.require(:study_application).permit(:person_id, :program_id)
  end
end
