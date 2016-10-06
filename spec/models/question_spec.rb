require 'rails_helper'

describe Question do
  describe 'association' do
    Then { is_expected.to belong_to(:questionnaire) }
    Then { is_expected.to have_many(:answers).dependent(:destroy) }
  end

  describe '#answers_by_person' do
    Given(:person_1) { create :person }
    Given(:person_2) { create :person }
    Given(:question) { create :question }

    Given!(:answer_1) { Answer.create(person: person_1, question: question, data: 'some') }
    Given!(:answer_2) { question.answers.build(person: person_2, question: question, data: 'some') }

    Then { expect(question.answers_by_person(person_1)).to eq([answer_1]) }
    And  { expect(question.answers_by_person(person_2)).to eq([answer_2]) }
  end
end
