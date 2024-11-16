class CollectAdministratorsBySchedulesService
  def self.call(schedules)
    groups_by_administrator = schedules.each_with_object({}) do |schedule, result|
      schedule.academic_groups.each do |group|
        result[group.administrator] ||= Set[]
        result[group.administrator].add(group)
      end
    end

    groups_by_administrator.delete(nil)

    groups_by_administrator
  end
end
