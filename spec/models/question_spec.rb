require 'rails_helper'

describe Question do
  describe 'association' do
    Then { expect(subject).to belong_to(:questionnaire) }
    Then { expect(subject).to have_many(:answers).dependent(:destroy) }
  end
end
