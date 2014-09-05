require 'spec_helper'

describe Answer do
  describe 'association' do
    it { should belong_to(:person) }
    it { should belong_to(:question) }
  end
end
