module Ui
  class ExaminationResultDestroyingInteraction < BaseInteraction
    def init
      resource.destroy

      @status = resource.destroyed? ? :no_content : :unprocessable_entity
    end

    def as_json(_opts = {})
      @_as_json ||= errors_json(resource) unless resource.destroyed?
    end
  end
end
