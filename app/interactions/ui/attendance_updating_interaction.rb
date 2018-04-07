module Ui
  class AttendanceUpdatingInteraction < BaseInteraction
    def init
      @status = resource.valid? ? :ok : :unprocessable_entity

      resource.save
    end

    def as_json(_opts = {})
      @as_json ||= if resource.valid? && resource.persisted?
        {
          attendance: {
            id: resource.id,
            revision: resource.revision,
            presence: resource.presence,
            scheduleId: resource.class_schedule_id,
            studentProfileId: resource.student_profile_id
          }
        }
      else
        errors_json(resource)
      end
    end
  end
end
