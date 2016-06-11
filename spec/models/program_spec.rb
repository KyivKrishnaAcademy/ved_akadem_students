require 'rails_helper'

describe Program do
  describe 'validation' do
    Then { is_expected.to validate_presence_of(:manager) }
    Then { is_expected.to validate_presence_of(:title_uk) }
    Then { is_expected.to validate_presence_of(:title_ru) }
    Then { is_expected.to validate_presence_of(:description_uk) }
    Then { is_expected.to validate_presence_of(:description_ru) }
  end

  describe 'association' do
    Then { is_expected.to have_many(:study_applications).dependent(:destroy) }
    Then { is_expected.to have_and_belong_to_many(:questionnaires) }
  end
end
