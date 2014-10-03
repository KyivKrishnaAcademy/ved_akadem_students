require 'rails_helper'

describe Question do
  describe 'association' do
    Then { is_expected.to belong_to(:questionnaire) }
    Then { is_expected.to have_many(:answers).dependent(:destroy) }
  end

  describe '#answer_by_person' do
    Given { @person_1 = create :person }
    Given { @person_2 = create :person }
    Given { @question = create :question }
    Given { @answer   = Answer.create(person: @person_1, question: @question, data: 'some') }

    Then  { expect(@question.answer_by_person(@person_1)).to eq(@answer) }
    And   { expect(@question.answer_by_person(@person_2)).not_to be_persisted }
  end
end
