# require 'rails_helper'

describe RefreshClassSchedulesMvJob do
  include ActiveJob::TestHelper

  describe 'perform' do
    Given(:check_flag) { Sidekiq.redis { |c| c.exists(:class_schedule_with_people_mv_refresh) != 0 } }

    Given { Sidekiq.redis { |c| c.set(:class_schedule_with_people_mv_refresh, 1) } }

    describe 'ensure flag exists before perform' do
      Then { expect(check_flag).to be(true) }
    end

    describe 'do perform' do
      Given(:perform_now) { perform_enqueued_jobs { RefreshClassSchedulesMvJob.perform_later } }

      describe 'deletes flag' do
        Given { allow(ClassScheduleWithPeople).to receive(:refresh) }

        When  { perform_now }

        Then  { expect(check_flag).to be(false) }
      end

      describe 'calls refresh' do
        Then { expect(ClassScheduleWithPeople).to receive(:refresh) }
        And  { perform_now }
      end
    end
  end
end
