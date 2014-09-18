require 'rails_helper'

describe QuestionnaireCompleteness do
  describe 'association' do
    Then { is_expected.to belong_to(:questionnaire) }
    Then { is_expected.to belong_to(:person) }
  end
end
