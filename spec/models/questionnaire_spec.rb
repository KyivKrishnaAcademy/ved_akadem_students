require 'spec_helper'

describe Questionnaire do
  describe 'association' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_and_belong_to_many(:study_applications) }
  end
end
