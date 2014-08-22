require 'spec_helper'

describe Telephone do
  describe 'DB table' do
    it { should have_db_column(:phone).of_type(:string) }
  end

  describe 'association' do
    it { should belong_to(:person) }
  end
end
