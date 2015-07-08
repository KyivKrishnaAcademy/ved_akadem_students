class Ui::ClassSchedulesController < Ui::BaseController
  def person
    authorize ClassSchedule, :ui_person?

    respond_with_interaction PersonClassSchedulesLoadingInteraction
  end
end
