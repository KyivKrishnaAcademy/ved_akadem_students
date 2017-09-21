require 'rails_helper'

describe StudentProfile do
  describe 'associtations' do
    Then { is_expected.to belong_to(:person) }
    Then { is_expected.to have_many(:group_participations).dependent(:destroy) }
    Then { is_expected.to have_many(:academic_groups).through(:group_participations) }
    Then { is_expected.to have_many(:attendances).dependent(:destroy) }
    Then { is_expected.to have_many(:class_schedules).through(:attendances) }
  end

  describe 'methods' do
    Given(:student_profile) { create :student_profile }
    Given(:group_1) { create :academic_group }
    Given(:group_2) { create :academic_group }

    describe '#move_to_group' do
      When { student_profile.move_to_group(group_1) }

      context 'first group' do
        Then { expect(student_profile.academic_groups).to eq([group_1]) }

        And do
          expect(student_profile.group_participations.find_by(academic_group_id: group_1.id).leave_date).to be_nil
        end
      end

      context 'second group' do
        Given { student_profile.academic_groups << group_2 }

        Then  { expect(student_profile.academic_groups).to contain_exactly(group_1, group_2) }

        And do
          expect(student_profile.group_participations.find_by(academic_group_id: group_1.id).leave_date).to be_nil
        end

        And do
          expect(student_profile.group_participations.find_by(academic_group_id: group_2.id).leave_date).to be_nil
        end
      end
    end

    describe '#active?' do
      subject { student_profile.active? }

      context 'no groups' do
        Then { is_expected.to be(false) }
      end

      context 'with group' do
        Given { student_profile.academic_groups << group_1 }

        context 'active' do
          Then { is_expected.to be(true) }
        end

        context 'inactive' do
          Given { student_profile.group_participations.first.leave! }

          Then  { is_expected.to be(false) }
        end
      end
    end
  end
end
