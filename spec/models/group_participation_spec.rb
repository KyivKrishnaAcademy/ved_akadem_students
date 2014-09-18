require 'rails_helper'

describe GroupParticipation do
  describe 'associations' do
    Then { is_expected.to belong_to(:student_profile) }
    Then { is_expected.to belong_to(:akadem_group) }
  end
end
