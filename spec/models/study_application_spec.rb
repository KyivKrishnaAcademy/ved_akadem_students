# require 'rails_helper'

describe StudyApplication do
  describe 'validation' do
    Then { is_expected.to validate_presence_of(:person) }
    Then { is_expected.to validate_presence_of(:program) }
    Then { is_expected.to validate_uniqueness_of(:person_id) }
  end

  describe 'association' do
    Then { is_expected.to belong_to(:person) }
    Then { is_expected.to belong_to(:program) }
  end
end
