require 'rails_helper'

describe Telephone do
  describe 'association' do
    Then { is_expected.to belong_to(:person) }
  end
end
