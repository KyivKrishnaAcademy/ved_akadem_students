# Preview all emails at http://localhost:3000/rails/mailers/schedules_notifier
class SchedulesNotifierPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/schedules_notifier/next_day
  def next_day
    SchedulesNotifierMailer.next_day(Person.first.id)
  end
end
