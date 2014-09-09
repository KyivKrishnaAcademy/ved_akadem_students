class QuestionnairePolicy < ApplicationPolicy
  def show_form?
    owned? || update_all?
  end

  def save_answers?
    owned? || update_all?
  end

  private

  def owned?
    QuestionnaireCompleteness.where(person_id: user.id, questionnaire_id: record.id).present?
  end
end
