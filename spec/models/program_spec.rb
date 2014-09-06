require 'spec_helper'

describe Program do
  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'association' do
    it { should have_many(:study_applications).dependent(:destroy) }
    it { should have_and_belong_to_many(:questionnaires) }
  end
end
