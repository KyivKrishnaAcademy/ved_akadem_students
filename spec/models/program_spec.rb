require 'rails_helper'

describe Program do
  describe 'validation' do
    Then { expect(subject).to validate_presence_of(:title) }
    Then { expect(subject).to validate_presence_of(:description) }
  end

  describe 'association' do
    Then { expect(subject).to have_many(:study_applications).dependent(:destroy) }
    Then { expect(subject).to have_and_belong_to_many(:questionnaires) }
  end
end
