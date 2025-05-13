# require 'rails_helper'

describe Program do
  describe 'validation' do
    Then { is_expected.to validate_presence_of(:manager) }
    Then { is_expected.to validate_presence_of(:title_uk) }
    Then { is_expected.to validate_presence_of(:title_ru) }
    Then { is_expected.to validate_presence_of(:description_uk) }
    Then { is_expected.to validate_presence_of(:description_ru) }
  end
end
