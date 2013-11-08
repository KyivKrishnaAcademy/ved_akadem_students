class AddColumnsToClassSchedule < ActiveRecord::Migration
  def change
    add_column :class_schedules, :date, :date
    add_column :class_schedules, :course_id, :integer
    add_column :class_schedules, :teacher_profile_id, :integer
    add_column :class_schedules, :akadem_group_id, :integer
  end
end
