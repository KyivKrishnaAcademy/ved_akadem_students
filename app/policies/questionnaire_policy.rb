class QuestionnairePolicy < BasePolicy
  class Scope < Scope
    def resolve
      if user.role_activity?('questionnaire:update_all')
        scope.all
      else
        scope.joins(:questionnaire_completenesses).where(questionnaire_completenesses: { person_id: user.id }).distinct
      end
    end
  end

  def show_form?
    owned? || update_all?
  end

  def save_answers?
    owned? || update_all?
  end

  def ui_index?
    user.can_act?(
      %w[
        program:edit
        program:new
      ]
    )
  end

  private

  def owned?
    QuestionnaireCompleteness.where(person_id: user.id, questionnaire_id: record.id).present?
  end
end
