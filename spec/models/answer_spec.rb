require 'spec_helper'

describe Answer do
  describe 'association' do
    it { should belong_to(:person) }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of(:data) }
    it { should validate_presence_of(:person) }
    it { should validate_presence_of(:question) }
  end
end
