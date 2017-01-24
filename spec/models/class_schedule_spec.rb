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

  Given(:group) { create :academic_group }

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
        Given(:student) { create :person }
        Given(:schedule) { build :class_schedule, academic_groups: [group], classroom: classroom }
        Given(:classroom) { create :classroom, roominess: 0 }
        Given(:error_message) do
          I18n.t(
            'activerecord.errors.models.class_schedule.attributes.classroom.roominess',
            actual: 0,
            required: 1
          )
        end

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
          Given do
            create(
              :class_schedule,
              resource_name => resource,
              start_time: '01.01.2015 12:00',
              finish_time: '01.01.2015 12:20'
            )
          end

          context 'overlaps on start' do
            Given(:schedule) do
              build(
                :class_schedule,
                resource_name => resource,
                start_time: '01.01.2015 11:00',
                finish_time: '01.01.2015 12:01'
              )
            end

            it_behaves_like :invalid
          end

          context 'overlaps on finish' do
            Given(:schedule) do
              build(
                :class_schedule,
                resource_name => resource,
                start_time: '01.01.2015 12:19',
                finish_time: '01.01.2015 12:40'
              )
            end

            it_behaves_like :invalid
          end

          context 'overlaps inside' do
            Given(:schedule) do
              build(
                :class_schedule,
                resource_name => resource,
                start_time: '01.01.2015 12:01',
                finish_time: '01.01.2015 12:19'
              )
            end

            it_behaves_like :invalid
          end

          context 'overlaps outside' do
            Given(:schedule) do
              build(
                :class_schedule,
                resource_name => resource,
                start_time: '01.01.2015 11:00',
                finish_time: '01.01.2015 13:00'
              )
            end

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
            Given do
              create(
                :class_schedule,
                resource_name => resource,
                start_time: '01.01.2015 11:00',
                finish_time: '01.01.2015 13:00'
              )
            end

            context 'in the future' do
              Given(:schedule) do
                build(
                  :class_schedule,
                  resource_name => resource,
                  start_time: '01.01.2015 14:00',
                  finish_time: '01.01.2015 15:00'
                )
              end

              Then { expect(schedule).to be_valid }
            end

            context 'in the past' do
              Given(:schedule) do
                build(
                  :class_schedule,
                  resource_name => resource,
                  start_time: '01.01.2015 09:00',
                  finish_time: '01.01.2015 10:00'
                )
              end

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
    Given(:teacher) { create :teacher_profile }
    Given(:schedule) { create :class_schedule, academic_groups: [group], teacher_profile: teacher }

    When { schedule.update(finish_time: schedule.finish_time + 5.minutes) }

    Then { expect(schedule).to be_valid }
  end

  describe 'methods' do
    describe '#real_class_schedule' do
      Given(:schedule) { create :class_schedule }

      Then { expect(schedule.real_class_schedule.id).to eq(schedule.id) }
    end

    describe '.by_group' do
      Given(:schedule_3) do
        create(
          :class_schedule,
          academic_groups: [group],
          start_time: Time.zone.now + 4.hours,
          finish_time: Time.zone.now + 5.hours
        )
      end

      Given(:schedule_1) do
        create(
          :class_schedule,
          academic_groups: [group],
          start_time: Time.zone.now + 1.hour,
          finish_time: Time.zone.now + 2.hours
        )
      end

      Given(:schedule_2) do
        create(
          :class_schedule,
          academic_groups: [group],
          start_time: Time.zone.now + 2.hours,
          finish_time: Time.zone.now + 3.hours
        )
      end

      Given(:past_schedule_1) do
        create(
          :class_schedule,
          academic_groups: [group],
          start_time: '01.01.2015 14:00',
          finish_time: '01.01.2015 15:00'
        )
      end

      Given(:past_schedule_3) do
        create(
          :class_schedule,
          academic_groups: [group],
          start_time: '03.01.2015 14:00',
          finish_time: '03.01.2015 15:00'
        )
      end

      Given(:past_schedule_2) do
        create(
          :class_schedule,
          academic_groups: [group],
          start_time: '02.01.2015 14:00',
          finish_time: '02.01.2015 15:00'
        )
      end

      Given!(:past_ids) { [past_schedule_3, past_schedule_2, past_schedule_1].map(&:id) }
      Given!(:future_ids) { [schedule_1, schedule_2, schedule_3].map(&:id) }

      Given(:result) { ClassSchedule.by_group(group.id, nil, direction).map(&:id) }

      context 'direction "future"' do
        Given(:direction) { 'future' }

        Then { expect(result).to eq(future_ids) }
      end

      context 'direction "any"' do
        Given(:direction) { 'any' }

        Then { expect(result).to eq(future_ids) }
      end

      context 'no direction' do
        Given(:direction) { nil }

        Then { expect(result).to eq(future_ids) }
      end

      context 'direction "past"' do
        Given(:direction) { 'past' }

        Then { expect(result).to eq(past_ids) }
      end
    end
  end
end
