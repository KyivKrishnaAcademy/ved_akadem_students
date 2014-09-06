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
end
