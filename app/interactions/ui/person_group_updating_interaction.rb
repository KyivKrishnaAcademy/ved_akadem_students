module Ui
  class PersonGroupUpdatingInteraction < BaseInteraction
    include ClassSchedulesRefreshable

    def init
      @person         = Person.find(params.require(:id))
      @academic_group = AcademicGroup.find(params.require(:group_id))

      (@person.student_profile || @person.create_student_profile).move_to_group(@academic_group)

      refresh_class_schedules_mv
    end

    def as_json(opts = {})
      {
        id: @academic_group.id,
        title: @academic_group.title,
        url: Rails.application.routes.url_helpers.academic_group_path(@academic_group)
      }
    end
  end
end
