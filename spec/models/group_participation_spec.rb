require 'rails_helper'

describe GroupParticipation do
  describe 'associations' do
    Then { is_expected.to belong_to(:student_profile) }
    Then { is_expected.to belong_to(:academic_group) }
  end

  describe '#set_join_date before save when' do
    context 'no date is set' do
      Given { @gp = GroupParticipation.create }

      Then  { expect(@gp.join_date).not_to be_nil }
    end

    context 'some date is set' do
      Given { @time = DateTime.current.yesterday }
      Given { @gp   = GroupParticipation.create(join_date: @time) }

      Then  { expect(@gp.join_date).to eq(@time) }
    end
  end

  describe '#leave!' do
    Given { @gp = GroupParticipation.create(leave_date: nil) }

    When  { @gp.leave! }

    Then  { expect(@gp.leave_date).not_to be_nil }
  end
end
