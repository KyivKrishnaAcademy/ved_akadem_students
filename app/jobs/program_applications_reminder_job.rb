class ProgramApplicationsReminderJob < ApplicationJob
  queue_as :default

  def perform
    manager_ids = Program
                    .where(id: StudyApplication.select('DISTINCT program_id'))
                    .pluck('DISTINCT manager_id')

    manager_ids.each do |manager_id|
      ProgramApplicationsReminderMailer
        .manager_remind(manager_id: manager_id)
        .deliver_later
    end
  end
end
