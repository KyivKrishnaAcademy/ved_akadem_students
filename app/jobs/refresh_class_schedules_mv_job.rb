class RefreshClassSchedulesMvJob < ApplicationJob
  queue_as :default

  def perform
    ClassScheduleWithPeople.refresh

    Sidekiq.redis { |c| c.del(:class_schedule_with_people_mv_refresh) }
  end
end
