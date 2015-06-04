require 'rails_helper'

describe ClassSchedule do
  describe 'associations' do
    Then { is_expected.to belong_to(:course) }
    Then { is_expected.to belong_to(:teacher_profile) }
    Then { is_expected.to have_many(:academic_group_schedules).dependent(:destroy) }
    Then { is_expected.to have_many(:academic_groups).through(:academic_group_schedules) }
    Then { is_expected.to belong_to(:classroom) }
    Then { is_expected.to have_many(:attendances).dependent(:destroy) }
  end

  describe 'validations' do
    describe 'generic' do
      Then { is_expected.to validate_presence_of(:course) }
      Then { is_expected.to validate_presence_of(:classroom) }
      Then { is_expected.not_to validate_presence_of(:teacher_profile) }
      Then { is_expected.not_to validate_presence_of(:academic_groups) }
      Then { is_expected.to validate_presence_of(:start_time) }
      Then { is_expected.to validate_presence_of(:finish_time) }
    end

    describe 'custom' do
      describe 'classroom roominess' do
        Given(:group) { create :academic_group}
        Given(:student) { create :person }
        Given(:schedule) { build :class_schedule, academic_groups: [group], classroom: classroom }
        Given(:classroom) { create :classroom }
        Given(:error_message) { I18n.t('activerecord.errors.models.class_schedule.attributes.classroom.roominess',
                                       actual: 0,
                                       required: 1) }

        Given { student.create_student_profile.move_to_group(group) }

        describe 'invalid' do
          Then { expect(schedule).not_to be_valid }
          And  { expect(schedule.errors.messages[:classroom]).to eq([error_message]) }
        end

        describe 'valid' do
          context 'no groups' do
            Given(:schedule) { build :class_schedule, classroom: classroom }

            Then { expect(schedule).to be_valid }
          end

          context 'good roominess' do
            Given(:classroom) { create :classroom, roominess: 1 }

            Then { expect(schedule).to be_valid }
          end
        end
      end
    end
  end
end
