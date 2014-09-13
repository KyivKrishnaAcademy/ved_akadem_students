require 'rails_helper'

describe Answer do
  describe 'association' do
    Then { expect(subject).to belong_to(:person) }
    Then { expect(subject).to belong_to(:question) }
  end

  describe 'validations' do
    Then { expect(subject).to validate_presence_of(:data) }
    Then { expect(subject).to validate_presence_of(:person) }
    Then { expect(subject).to validate_presence_of(:question) }
  end
end
