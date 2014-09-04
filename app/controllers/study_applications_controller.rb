class StudyApplicationsController < ApplicationController
  include StudyApplicationable

  inherit_resources
  actions :create, :destroy
  respond_to :js

  def create
    create! do |success|
      success.js { common_variables_and_render }
    end
  end

  def destroy
    destroy! do |success|
      success.js { common_variables_and_render }
    end
  end

  private

  def common_variables_and_render
    set_programs_and_new_application

    render partial: 'common'
  end

  def permitted_params
    params.permit(:id, study_application: [:person_id, :program_id])
  end
end
