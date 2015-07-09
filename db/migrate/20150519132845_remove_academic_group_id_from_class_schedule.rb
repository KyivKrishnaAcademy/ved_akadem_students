class RemoveAcademicGroupIdFromClassSchedule < ActiveRecord::Migration
  def change
    remove_column :class_schedules, :academic_group_id, :integer
  end
end
