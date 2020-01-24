require 'rails_helper'

describe GroupParticipation do
  describe 'validations' do
    Then { is_expected.to validate_presence_of(:academic_group) }
    Then { is_expected.to validate_presence_of(:student_profile) }
  end

  describe 'associations' do
    Then { is_expected.to belong_to(:student_profile) }
    Then { is_expected.to belong_to(:academic_group) }
  end

  describe '#set_join_date before save when' do
    context 'no date is set' do
      Given(:gp) { create :group_participation }

      Then { expect(gp.join_date).not_to be_nil }
    end

    context 'some date is set' do
      Given(:time) { DateTime.current.yesterday }
      Given(:gp) { create :group_participation, join_date: time }

      Then { expect(gp.join_date).to eq(time) }
    end
  end

  describe '#leave!' do
    Given(:group) { create :academic_group }
    Given(:sp) { create :student_profile, person: person }
    Given(:gp) { create :group_participation, student_profile: sp, academic_group: group, leave_date: nil }

    When { gp.leave! }

    shared_examples_for :dont_send_email do
      Given { expect(GroupTransactionsMailer).not_to receive(:leave_the_group) }

      Then { expect(gp.leave_date).not_to be_nil }
    end

    context 'valid email' do
      Given(:person) { create :person }

      context 'active group' do
        Given(:mail) { double }

        Given do
          expect(GroupTransactionsMailer).to receive(:leave_the_group).with(gp.academic_group, person).and_return(mail)

          expect(mail).to receive(:deliver_later)
        end

        Then { expect(gp.leave_date).not_to be_nil }
      end

      context 'inactive group' do
        Given(:group) { create :academic_group, graduated_at: Time.zone.now }

        include_examples :dont_send_email
      end
    end

    context 'invalid email' do
      Given(:person) { create :person, fake_email: true }

      include_examples :dont_send_email
    end

    context 'spam complained' do
      Given(:person) { create :person, spam_complain: true }

      include_examples :dont_send_email
    end
  end
end
