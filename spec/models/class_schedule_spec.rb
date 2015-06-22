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
        Given(:classroom) { create :classroom, roominess: 0 }
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

      shared_examples :availability do |resource_is_optional|
        context 'invalid' do
          Given { create :class_schedule, resource_name => resource,
                         start_time: '01.01.2015 12:00',
                         finish_time: '01.01.2015 12:20' }

          context 'overlaps on start' do
            Given(:schedule) { build :class_schedule, resource_name => resource,
                                     start_time: '01.01.2015 11:00',
                                     finish_time: '01.01.2015 12:01' }

            it_behaves_like :invalid
          end

          context 'overlaps on finish' do
            Given(:schedule) { build :class_schedule, resource_name => resource,
                                     start_time: '01.01.2015 12:19',
                                     finish_time: '01.01.2015 12:40' }

            it_behaves_like :invalid
          end

          context 'overlaps inside' do
            Given(:schedule) { build :class_schedule, resource_name => resource,
                                     start_time: '01.01.2015 12:01',
                                     finish_time: '01.01.2015 12:19' }

            it_behaves_like :invalid
          end

          context 'overlaps outside' do
            Given(:schedule) { build :class_schedule, resource_name => resource,
                                     start_time: '01.01.2015 11:00',
                                     finish_time: '01.01.2015 13:00' }

            it_behaves_like :invalid
          end
        end

        context 'valid' do
          if resource_is_optional
            context 'without resource' do
              Given(:schedule) { build :class_schedule }

              Then { expect(schedule).to be_valid }
            end
          end

          context 'with no overlapping' do
            Given { create :class_schedule, resource_name => resource,
                           start_time: '01.01.2015 11:00',
                           finish_time: '01.01.2015 13:00' }

            context 'in the future' do
              Given(:schedule) { build :class_schedule, resource_name => resource,
                                       start_time: '01.01.2015 14:00',
                                       finish_time: '01.01.2015 15:00' }

              Then { expect(schedule).to be_valid }
            end

            context 'in the past' do
              Given(:schedule) { build :class_schedule, resource_name => resource,
                                       start_time: '01.01.2015 09:00',
                                       finish_time: '01.01.2015 10:00' }

              Then { expect(schedule).to be_valid }
            end
          end
        end
      end

      describe 'teacher availability' do
        Given(:resource) { create resource_name }
        Given(:resource_name) { :teacher_profile }

        shared_examples :invalid do
          Given(:error_message) do
            I18n.t('activerecord.errors.models.class_schedule.attributes.teacher_profile.availability')
          end

          Then { expect(schedule).not_to be_valid }
          And  { expect(schedule.errors.messages[resource_name]).to eq([error_message]) }
        end

        it_behaves_like :availability, true
      end

      describe 'classroom availability' do
        Given(:resource) { create resource_name }
        Given(:resource_name) { :classroom }

        shared_examples :invalid do
          Given(:error_message) do
            I18n.t('activerecord.errors.models.class_schedule.attributes.classroom.availability')
          end

          Then { expect(schedule).not_to be_valid }
          And  { expect(schedule.errors.messages[resource_name]).to eq([error_message]) }
        end

        it_behaves_like :availability, false
      end

      describe 'academic_groups availability' do
        Given(:group_1) { create :academic_group }
        Given(:group_2) { create :academic_group }
        Given(:resource) { [group_1, group_2] }
        Given(:resource_name) { :academic_groups }

        shared_examples :invalid do
          Given(:error_message) do
            I18n.t('activerecord.errors.models.class_schedule.attributes.academic_groups.availability',
                   groups: resource.map(&:title).sort.join(', '))
          end

          Then { expect(schedule).not_to be_valid }
          And  { expect(schedule.errors.messages[resource_name]).to eq([error_message]) }
        end

        it_behaves_like :availability, true
      end
    end
  end

  describe 'able to update existing with overlapping time' do
    Given(:group) { create :academic_group }
    Given(:teacher) { create :teacher_profile }
    Given(:schedule) { create :class_schedule, academic_groups: [group], teacher_profile: teacher }

    When { schedule.update(finish_time: schedule.finish_time + 5.minutes) }

    Then { expect(schedule).to be_valid }
  end

  describe '.personal_schedule' do
    Given(:user) { create :person }
    Given(:time) { DateTime.current + 1.week }
    Given(:ex_group) { create :academic_group }
    Given(:alien_group) { create :academic_group }
    Given(:active_group) { create :academic_group }
    Given(:graduated_group) { create :academic_group }

    Given { user.create_student_profile(academic_groups: [ex_group, active_group, graduated_group]) }
    Given { graduated_group.update_column(:graduated_at, '2015.01.01 01:00')}
    Given { ex_group.group_participations.first.update_column(:leave_date, '2015.01.01 01:00') }

    Given!(:class_for_graduated_group) do
      create :class_schedule, subject: 'graduated_group', academic_groups: [graduated_group],
                              start_time: time.change(hour: 12), finish_time: time.change(hour: 13)
    end
    Given!(:past_class_for_active_group) do
      create :class_schedule, subject: 'active_group_past', academic_groups: [active_group],
                              start_time: '2015.01.01 13:00', finish_time: '2015.01.01 14:00'
    end
    Given!(:class_for_active_group) do
      create :class_schedule, subject: 'active_group', academic_groups: [active_group],
                              start_time: time.change(hour: 13), finish_time: time.change(hour: 14)
    end
    Given!(:class_for_all_groups) do
      create :class_schedule, subject: 'all_groups', academic_groups: [ex_group, active_group, graduated_group],
                              start_time: time.change(hour: 11), finish_time: time.change(hour: 12)
    end
    Given!(:class_for_ex_group) do
      create :class_schedule, subject: 'ex_group',
                              academic_groups: [ex_group],
                              start_time: time.change(hour: 15), finish_time: time.change(hour: 16)
    end
    Given!(:class_for_teacher) do
      create :class_schedule, subject: 'teacher', teacher_profile: user.create_teacher_profile,
                              start_time: time.change(hour: 10), finish_time: time.change(hour: 11)
    end
    Given!(:class_for_alien_group) do
      create :class_schedule, subject: 'alien_group', academic_groups: [alien_group],
                              start_time: time.change(hour: 8), finish_time: time.change(hour: 9)
    end

    Given(:subject) { ClassSchedule.personal_schedule(user) }
    Given(:expected_schedules) { %w(teacher all_groups active_group) }

    Then { expect(subject.pluck(:subject)).to eq(expected_schedules) }
    And  { expect(subject.total_pages).to be(1) }
  end
end
