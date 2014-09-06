require 'spec_helper'

describe StudyApplication do
  describe 'validation' do
    it { should validate_presence_of(:person_id) }
    it { should validate_presence_of(:program_id) }
  end

  describe 'association' do
    it { should belong_to(:person) }
    it { should belong_to(:program) }
  end
end
