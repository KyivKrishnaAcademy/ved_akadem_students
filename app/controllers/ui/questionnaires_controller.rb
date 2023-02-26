module Ui
  class QuestionnairesController < Ui::BaseController
    def index
      authorize Questionnaire, :ui_index?

      respond_with_interaction Ui::QuestionnairesLoadingInteraction
    end
  end
end
