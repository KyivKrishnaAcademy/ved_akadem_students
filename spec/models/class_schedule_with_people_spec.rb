require 'rails_helper'

describe ClassScheduleWithPeople do
  When { init_schedules_mv }

  describe 'readonly' do
    Given { create :class_schedule }

    Given(:instance) { ClassScheduleWithPeople.first }

    Then { expect { ClassScheduleWithPeople.create }.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect { instance.save }.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect { instance.update_attributes(subject: 'other text') }.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect { instance.update_column(:subject, 'other text') }.to raise_error(ActiveRecord::ActiveRecordError) }
    Then { expect { instance.delete }.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect { instance.destroy }.to raise_error(ActiveRecord::ReadOnlyRecord) }

    Then do
      expect { instance.update_attribute(:subject, 'other text') }.to raise_error(ActiveRecord::ActiveRecordError)
    end
  end

  describe 'methods' do
    describe '.refresh' do
      Given(:updated_subject) { 'My special subject' }

      Given!(:class_schedule) { create :class_schedule }

      When { class_schedule.update_column(:subject, updated_subject) }

      subject { ClassScheduleWithPeople.find(class_schedule.id).subject }

      context 'not refreshed' do
        Then { is_expected.not_to eq(updated_subject) }
      end

      context 'refreshed' do
        When { ClassScheduleWithPeople.refresh }

        Then { is_expected.to eq(updated_subject) }
      end
    end

    describe '.refresh_later' do
      describe 'do nothing' do
        Given { Sidekiq.redis { |c| c.set(:class_schedule_with_people_mv_refresh, 1) } }

        Then  { expect(RefreshClassSchedulesMvJob).not_to receive(:set) }
        And   { ClassScheduleWithPeople.refresh_later || true }
      end

      describe 'do perform' do
        def lock_status
          Sidekiq.redis { |c| c.exists(:class_schedule_with_people_mv_refresh) }
        end

        Then { expect(lock_status).to be(false) }
        And  { expect(RefreshClassSchedulesMvJob).to receive_message_chain(:set, :perform_later) }
        And  { ClassScheduleWithPeople.refresh_later || true }
        And  { expect(lock_status).to be(true) }
      end
    end

    describe '#real_class_schedule' do
      Given!(:class_schedule) { create :class_schedule }

      Then { expect(ClassScheduleWithPeople.find(class_schedule.id).real_class_schedule).to eq(class_schedule) }
    end

    describe '.personal_schedule' do
      Given(:user) { create :person }
      Given(:time) { DateTime.current + 1.week }
      Given(:ex_group) { create :academic_group }
      Given(:alien_group) { create :academic_group }
      Given(:active_group) { create :academic_group }
      Given(:graduated_group) { create :academic_group }

      Given { user.create_student_profile(academic_groups: [ex_group, active_group, graduated_group]) }
      Given { graduated_group.update_column(:graduated_at, '2015.01.01 01:00') }
      Given { ex_group.group_participations.first.update_column(:leave_date, '2015.01.01 01:00') }

      Given!(:class_for_graduated_group) do
        create(
          :class_schedule,
          subject: 'graduated_group',
          academic_groups: [graduated_group],
          start_time: time.change(hour: 12),
          finish_time: time.change(hour: 13)
        )
      end

      Given!(:past_class_for_active_group) do
        create(
          :class_schedule,
          subject: 'active_group_past',
          academic_groups: [active_group],
          start_time: '2015.01.01 13:00',
          finish_time: '2015.01.01 14:00'
        )
      end

      Given!(:class_for_active_group) do
        create(
          :class_schedule,
          subject: 'active_group',
          academic_groups: [active_group],
          start_time: time.change(hour: 13),
          finish_time: time.change(hour: 14)
        )
      end

      Given!(:class_for_all_groups) do
        create(
          :class_schedule,
          subject: 'all_groups',
          academic_groups: [ex_group, active_group, graduated_group],
          start_time: time.change(hour: 11),
          finish_time: time.change(hour: 12)
        )
      end

      Given!(:class_for_ex_group) do
        create(
          :class_schedule,
          subject: 'ex_group',
          academic_groups: [ex_group],
          start_time: time.change(hour: 15),
          finish_time: time.change(hour: 16)
        )
      end

      Given!(:class_for_teacher) do
        create(
          :class_schedule,
          subject: 'teacher',
          teacher_profile: user.create_teacher_profile,
          academic_groups: [active_group],
          start_time: time.change(hour: 10),
          finish_time: time.change(hour: 11)
        )
      end

      Given!(:class_for_alien_group) do
        create(
          :class_schedule,
          subject: 'alien_group',
          academic_groups: [alien_group],
          start_time: time.change(hour: 8),
          finish_time: time.change(hour: 9)
        )
      end

      Given(:subject) { ClassScheduleWithPeople.personal_schedule(user.id) }
      Given(:expected_schedules) { %w(teacher all_groups active_group) }

      Then { expect(subject.pluck(:subject)).to eq(expected_schedules) }
      And  { expect(subject.total_pages).to be(1) }
    end
  end
end
