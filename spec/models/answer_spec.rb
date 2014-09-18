require 'rails_helper'

describe Answer do
  describe 'association' do
    Then { is_expected.to belong_to(:person) }
    Then { is_expected.to belong_to(:question) }
  end

  describe 'validations' do
    Then { is_expected.to validate_presence_of(:data) }
    Then { is_expected.to validate_presence_of(:person) }
    Then { is_expected.to validate_presence_of(:question) }
  end
end
