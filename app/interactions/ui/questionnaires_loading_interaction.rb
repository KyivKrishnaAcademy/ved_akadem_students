module Ui
  class QuestionnairesLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      @json_root = :questionnaires
      @resource  = Questionnaire.ilike("title_#{user.locale}", params[:q])
    end

    def serialize_resource(questionnaire)
      {
        id: questionnaire.id,
        text: questionnaire["title_#{user.locale}"]
      }
    end
  end
end
