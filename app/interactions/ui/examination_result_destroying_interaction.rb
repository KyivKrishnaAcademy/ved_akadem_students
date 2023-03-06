module Ui
  class ExaminationResultDestroyingInteraction < BaseInteraction
    def init
      resource.destroy
      decrement_indirect_counters

      @status = resource.destroyed? ? :no_content : :unprocessable_entity
    end

    def as_json(_opts = {})
      @as_json ||= errors_json(resource) unless resource.destroyed?
    end

    def decrement_indirect_counters
      return unless resource.destroyed?

      Course.update_counters(resource.course.id, examination_results_count: -1)
    end
  end
end
