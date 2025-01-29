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

      context 'do nothing' do
        before { Sidekiq.redis { |conn| conn.set(:class_schedule_with_people_mv_refresh, 1) == 1 } }

        it 'does not enqueue the job' do
          expect(RefreshClassSchedulesMvJob).not_to receive(:set)
          ClassScheduleWithPeople.refresh_later
        end
      end

      context 'do perform' do
        def lock_status
          Sidekiq.redis { |conn| conn.exists(:class_schedule_with_people_mv_refresh) } == 1
        end

        it 'sets the lock and enqueues the job' do
          expect(lock_status).to be(false) # Ключа еще нет
          expect(RefreshClassSchedulesMvJob).to receive_message_chain(:set, :perform_later)
          ClassScheduleWithPeople.refresh_later
          expect(lock_status).to be(true) # Ключ должен быть установлен
        end
      end
    end

    describe '#real_class_schedule' do
      Given!(:class_schedule) { create :class_schedule }

      Then { expect(ClassScheduleWithPeople.find(class_schedule.id).real_class_schedule).to eq(class_schedule) }
    end

    describe '.personal_schedule_by_direction' do
      # Логика для этого теста остается без изменений
    end
  end
end