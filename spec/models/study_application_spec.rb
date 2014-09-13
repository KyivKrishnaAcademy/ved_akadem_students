require 'rails_helper'

describe StudyApplication do
  describe 'validation' do
    Then { expect(subject).to validate_presence_of(:person_id) }
    Then { expect(subject).to validate_presence_of(:program_id) }
  end

  describe 'association' do
    Then { expect(subject).to belong_to(:person) }
    Then { expect(subject).to belong_to(:program) }
  end
end
