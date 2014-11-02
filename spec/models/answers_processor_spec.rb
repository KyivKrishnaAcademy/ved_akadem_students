require 'rails_helper'

describe AnswersProcessor do
  Given { @questionnaire = create :questionnaire }
  Given { @person        = create :person }

  subject { AnswersProcessor.new(@questionnaire, @person) }

  describe '#process!' do
    Given { @completeness  = QuestionnaireCompleteness.create(person: @person, questionnaire: @questionnaire) }

    When  { subject.process! }

    Then  { expect(@completeness.reload.completed?).to be(true) }
  end
end
