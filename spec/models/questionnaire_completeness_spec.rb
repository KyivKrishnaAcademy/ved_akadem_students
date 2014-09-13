require 'rails_helper'

describe QuestionnaireCompleteness do
  describe 'association' do
    Then { expect(subject).to belong_to(:questionnaire) }
    Then { expect(subject).to belong_to(:person) }
  end
end
