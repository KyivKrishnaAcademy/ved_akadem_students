class AnswersProcessor
  def initialize(questionnaire, person)
    @questionnaire  = questionnaire
    @person         = person
  end

  def process!
    complete!
  end

  private

    def complete!
      QuestionnaireCompleteness.find_by(person: @person, questionnaire: @questionnaire).update_column(:completed, true)
    end
end
