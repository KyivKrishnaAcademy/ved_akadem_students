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

      describe 'duration' do
        context 'invalid' do
          shared_examples :invalid do
            Given(:error_message) { I18n.t('activerecord.errors.models.class_schedule.wrong_times') }

            Then { expect(schedule).not_to be_valid }
            And  { expect(schedule.errors.messages[:start_time]).to eq([error_message]) }
            And  { expect(schedule.errors.messages[:finish_time]).to eq([error_message]) }
          end

          context 'finish is behind start' do
            Given(:schedule) { build :class_schedule, start_time: '01.01.2015 12:01', finish_time: '01.01.2015 12:00' }

            it_behaves_like :invalid
          end

          context 'duration is less then 10 minutes' do
            Given(:schedule) { build :class_schedule, start_time: '01.01.2015 12:00', finish_time: '01.01.2015 12:09' }

            it_behaves_like :invalid
          end

          context 'duration is more then a day' do
            Given(:schedule) { build :class_schedule, start_time: '01.01.2015 12:00', finish_time: '02.01.2015 12:00' }

            it_behaves_like :invalid
          end
        end

        context 'valid' do
          Given(:schedule) { build :class_schedule }

          Then { expect(schedule).to be_valid }
        end
      end

      describe 'teacher availability' do
        Given(:teacher_profile) { create :teacher_profile }

        context 'invalid' do
          shared_examples :invalid do
            Given(:error_message) do
              I18n.t('activerecord.errors.models.class_schedule.attributes.teacher_profile.availability')
            end

            Then { expect(schedule).not_to be_valid }
            And  { expect(schedule.errors.messages[:teacher_profile]).to eq([error_message]) }
          end

          Given { create :class_schedule, teacher_profile: teacher_profile,
                                          start_time: '01.01.2015 12:00',
                                          finish_time: '01.01.2015 12:20' }

          context 'overlaps on start' do
            Given(:schedule) { build :class_schedule, teacher_profile: teacher_profile,
                                                      start_time: '01.01.2015 11:00',
                                                      finish_time: '01.01.2015 12:01' }

            it_behaves_like :invalid
          end

          context 'overlaps on finish' do
            Given(:schedule) { build :class_schedule, teacher_profile: teacher_profile,
                                                      start_time: '01.01.2015 12:19',
                                                      finish_time: '01.01.2015 12:40' }

            it_behaves_like :invalid
          end

          context 'overlaps inside' do
            Given(:schedule) { build :class_schedule, teacher_profile: teacher_profile,
                                                      start_time: '01.01.2015 12:01',
                                                      finish_time: '01.01.2015 12:19' }

            it_behaves_like :invalid
          end

          context 'overlaps outside' do
            Given(:schedule) { build :class_schedule, teacher_profile: teacher_profile,
                                                      start_time: '01.01.2015 11:00',
                                                      finish_time: '01.01.2015 13:00' }

            it_behaves_like :invalid
          end
        end

        context 'valid' do
          context 'with profile' do
            Given(:schedule) { build :class_schedule, teacher_profile: teacher_profile }

            Then { expect(schedule).to be_valid }
          end

          context 'without profile' do
            Given(:schedule) { build :class_schedule }

            Then { expect(schedule).to be_valid }
          end

          context 'with no overlapping' do
            Given { create :class_schedule, teacher_profile: teacher_profile,
                                            start_time: '01.01.2015 11:00',
                                            finish_time: '01.01.2015 13:00' }

            context 'in the future' do
              Given(:schedule) { build :class_schedule, teacher_profile: teacher_profile,
                                                        start_time: '01.01.2015 14:00',
                                                        finish_time: '01.01.2015 15:00' }

              Then { expect(schedule).to be_valid }
            end

            context 'in the past' do
              Given(:schedule) { build :class_schedule, teacher_profile: teacher_profile,
                                                        start_time: '01.01.2015 09:00',
                                                        finish_time: '01.01.2015 10:00' }

              Then { expect(schedule).to be_valid }
            end
          end
        end
      end
    end
  end
end
