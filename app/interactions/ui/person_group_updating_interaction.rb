module Ui
  class PersonGroupUpdatingInteraction < BaseInteraction
    def init
      person          = params.require(:person)
      @academic_group = AcademicGroup.find(params.require(:group_id))

      (person.student_profile || person.create_student_profile).move_to_group(@academic_group)

      GroupTransactionsMailer.join_the_group(@academic_group, person).deliver_later
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
