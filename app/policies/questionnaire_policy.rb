class QuestionnairePolicy < BasePolicy
  class Scope < Scope
    def resolve
      if Pundit.policy(user, Questionnaire).update_all?
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
    (user_activities & ['program:update', 'program:create']).any?
  end

  private

  def owned?
    QuestionnaireCompleteness.where(person_id: user.id, questionnaire_id: record.id).present?
  end
end
