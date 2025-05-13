class RemoveAcademicGroupIdFromClassSchedule < ActiveRecord::Migration[5.0]
  def change
    remove_column :class_schedules, :academic_group_id, :integer
  end
end
