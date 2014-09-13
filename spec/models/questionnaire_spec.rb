require 'rails_helper'

describe Questionnaire do
  describe 'association' do
    Then { expect(subject).to have_many(:questions).dependent(:destroy) }
    Then { expect(subject).to have_many(:questionnaire_completenesses).dependent(:destroy) }
    Then { expect(subject).to have_many(:people).through(:questionnaire_completenesses) }
    Then { expect(subject).to have_and_belong_to_many(:programs) }
  end

  describe 'validations' do
    Then { expect(subject).to validate_presence_of(:title) }
  end

  describe '#complete!' do
    Given { @questionnaire = create :questionnaire }
    Given { @person        = create :person }
    Given { @completeness  = QuestionnaireCompleteness.create(person: @person, questionnaire: @questionnaire) }

    When  { @questionnaire.complete!(@person.id) }

    Then  { expect(@completeness.reload.completed?).to be(true) }
  end
end
