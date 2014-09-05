require 'spec_helper'

describe Question do
  describe 'association' do
    it { should belong_to(:questionnaire) }
    it { should have_many(:answers).dependent(:destroy) }
  end
end
