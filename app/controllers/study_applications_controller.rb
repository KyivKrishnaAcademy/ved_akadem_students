class StudyApplicationsController < ApplicationController
  include StudyApplicationable

  inherit_resources
  actions :create, :destroy
  respond_to :js

  after_filter :verify_authorized

  def create
    authorize build_resource

    create! do |success|
      success.js do
        resource.person.add_application_questionnaires

        set_programs_and_new_application(permitted_params[:study_application][:person_id])

        render partial: 'common'
      end
    end
  end

  def destroy
    authorize resource

    destroy! do |success|
      success.js do
        resource.person.remove_application_questionnaires(resource)

        set_programs_and_new_application

        render partial: 'common'
      end
    end
  end

  private

  def permitted_params
    params.permit(:id, study_application: [:person_id, :program_id])
  end
end
