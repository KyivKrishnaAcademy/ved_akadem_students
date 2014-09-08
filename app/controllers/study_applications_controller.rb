class StudyApplicationsController < ApplicationController
  include StudyApplicationable

  inherit_resources
  actions :create, :destroy
  respond_to :js

  after_filter :verify_authorized

  def create
    create! do |success|
      success.js do
        resource.person.add_application_questionnaires

        common_variables_and_render
      end
    end
  end

  def destroy
    destroy! do |success|
      success.js do
        resource.person.remove_application_questionnaires(resource)

        common_variables_and_render
      end
    end
  end

  private

  def resource
    authorize super

    super
  end

  def common_variables_and_render
    set_programs_and_new_application

    render partial: 'common'
  end

  def permitted_params
    params.permit(:id, study_application: [:person_id, :program_id])
  end
end
