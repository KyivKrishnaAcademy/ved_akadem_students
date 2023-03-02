require 'rails_helper'

describe Questionnaire do
  describe 'validations' do
    Then { is_expected.to validate_presence_of(:title_uk) }
    Then { is_expected.to validate_presence_of(:title_ru) }
  end
end
