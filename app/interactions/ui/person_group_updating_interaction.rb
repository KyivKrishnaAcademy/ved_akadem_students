module Ui
  class PersonGroupUpdatingInteraction < BaseInteraction
    def init
      @academic_group = AcademicGroup.find(params.require(:group_id))

      (resource.student_profile || resource.create_student_profile).move_to_group(@academic_group)

      GroupTransactionsMailer.join_the_group(@academic_group, resource).deliver_later
    end

    def as_json(_opts = {})
      {
        id: @academic_group.id,
        title: @academic_group.title,
        url: Rails.application.routes.url_helpers.academic_group_path(@academic_group)
      }
    end
  end
end
