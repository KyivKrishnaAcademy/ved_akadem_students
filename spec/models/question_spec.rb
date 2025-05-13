# require 'rails_helper'

describe Question do
  describe 'association' do
    Then { is_expected.to belong_to(:questionnaire) }
    Then { is_expected.to have_many(:answers).dependent(:destroy) }
  end
end
