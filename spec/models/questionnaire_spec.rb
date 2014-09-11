require 'spec_helper'

describe Questionnaire do
  describe 'association' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:questionnaire_completenesses).dependent(:destroy) }
    it { should have_many(:people).through(:questionnaire_completenesses) }
    it { should have_and_belong_to_many(:programs) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe '#complete!' do
    Given { @questionnaire = create :questionnaire }
    Given { @person        = create :person }
    Given { @completeness  = QuestionnaireCompleteness.create(person: @person, questionnaire: @questionnaire) }

    When  { @questionnaire.complete!(@person.id) }
    Then  { @completeness.reload.completed?.should be_true }
  end
end
