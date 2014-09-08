class QuestionnairePolicy < ApplicationPolicy
  def show_form?
    owned? || update_all?
  end

  def save_answers?
    owned? || update_all?
  end

  private

  def owned?
    Questionnaire.joins(:questionnaire_completenesses).
                  where(questionnaire_completenesses: {person_id: user.id}, id: record.id).present?
  end
end
