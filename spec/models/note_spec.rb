require 'rails_helper'

describe Note do
  describe 'associations' do
    Then { is_expected.to belong_to(:person) }
  end

  describe 'validations' do
    Then { is_expected.to validate_presence_of(:date) }
    Then { is_expected.to validate_presence_of(:message) }
    Then { is_expected.to validate_presence_of(:person) }
  end
end
