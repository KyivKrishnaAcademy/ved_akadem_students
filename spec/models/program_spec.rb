require 'spec_helper'

describe Program do
  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'association' do
    it { should have_many(:study_applications).dependent(:destroy) }
  end
end
