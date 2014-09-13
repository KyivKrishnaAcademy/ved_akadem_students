require 'rails_helper'

describe GroupParticipation do
  describe 'associations' do
    Then { expect(subject).to belong_to(:student_profile) }
    Then { expect(subject).to belong_to(:akadem_group) }
  end
end
