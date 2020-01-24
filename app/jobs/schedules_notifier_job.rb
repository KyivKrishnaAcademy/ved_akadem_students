class SchedulesNotifierJob < ApplicationJob
  queue_as :default

  def perform
    people_ids_with_real_email.each { |id| SchedulesNotifierMailer.next_day(id).deliver_later }
  end

  private

  def people_ids
    ClassScheduleWithPeople
      .next_day
      .pluck(:teacher_id, :people_ids)
      .flatten
  end

  def people_ids_with_real_email
    Person.where(id: people_ids, fake_email: false, spam_complain: false, notify_schedules: true).ids
  end
end
