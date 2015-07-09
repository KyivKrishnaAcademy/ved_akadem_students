class Ui::ClassSchedulesController < Ui::BaseController
  def person
    authorize ClassSchedule, :ui_person?

    respond_with_interaction PersonClassSchedulesLoadingInteraction
  end

  def academic_group
    authorize AcademicGroup.find(params[:id]), :show?

    respond_with_interaction GroupClassSchedulesLoadingInteraction
  end
end
