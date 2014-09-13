require 'rails_helper'

describe Role do
  describe 'association' do
    Then { expect(subject).to have_and_belong_to_many(:people) }
  end

  describe 'validations' do
    Then { expect(subject).to validate_presence_of(:name) }
    And  { expect(subject).to ensure_length_of(:name).is_at_most(30) }

    Then { expect(subject).to validate_presence_of(:activities) }
  end
end
