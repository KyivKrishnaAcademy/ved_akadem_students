require 'spec_helper'

describe QuestionnaireCompleteness do
  describe 'association' do
    it { should belong_to(:questionnaire) }
    it { should belong_to(:person) }
  end
end
