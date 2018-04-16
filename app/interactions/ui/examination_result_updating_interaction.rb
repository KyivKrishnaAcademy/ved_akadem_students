module Ui
  class ExaminationResultUpdatingInteraction < BaseInteraction
    def init
      @status = resource.valid? ? :ok : :unprocessable_entity

      resource.save
    end

    def as_json(_opts = {})
      @as_json ||= if resource.valid? && resource.persisted?
        {
          examinationResult: {
            id: resource.id,
            score: resource.score,
            examinationId: resource.examination_id,
            studentProfileId: resource.student_profile_id
          }
        }
      else
        errors_json(resource)
      end
    end
  end
end
