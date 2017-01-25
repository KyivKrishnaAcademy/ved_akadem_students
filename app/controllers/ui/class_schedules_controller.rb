module Ui
  class ClassSchedulesController < Ui::BaseController
    def person
      authorize ClassSchedule, :ui_person?

      respond_with_interaction Ui::PersonClassSchedulesLoadingInteraction
    end

    def academic_group
      authorize AcademicGroup.find(params[:id]), :show?

      respond_with_interaction Ui::GroupClassSchedulesLoadingInteraction
    end

    def index
      authorize ClassSchedule

      respond_with_interaction Ui::ClassSchedulesLoadingInteraction
    end
  end
end
