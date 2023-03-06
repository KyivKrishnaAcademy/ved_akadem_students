module Ui
  class ExaminationResultUpdatingInteraction < BaseInteraction
    def init
      @status = resource.valid? ? :ok : :unprocessable_entity

      resource.save
      increment_indirect_counters
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

    def increment_indirect_counters
      return unless resource.id_previously_changed?

      Course.update_counters(resource.course.id, examination_results_count: 1)
    end
  end
end
