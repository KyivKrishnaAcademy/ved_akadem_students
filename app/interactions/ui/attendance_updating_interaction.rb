module Ui
  class AttendanceUpdatingInteraction < BaseInteraction
    def init
      @status = resource.valid? ? :ok : :unprocessable_entity

      resource.save
    end

    def as_json(_opts = {})
      @_as_json ||= if resource.valid? && resource.persisted?
        {
          attendance: { id: resource.id, presence: resource.presence }
        }
      else
        errors_json(resource)
      end
    end
  end
end
