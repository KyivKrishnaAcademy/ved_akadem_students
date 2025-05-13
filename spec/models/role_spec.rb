# require 'rails_helper'

describe Role do
  describe 'association' do
    Then { is_expected.to have_and_belong_to_many(:people) }
  end

  describe 'validations' do
    Then { is_expected.to validate_presence_of(:name) }
    And  { is_expected.to validate_length_of(:name).is_at_most(30) }

    Then { is_expected.to validate_presence_of(:activities) }
  end
end
