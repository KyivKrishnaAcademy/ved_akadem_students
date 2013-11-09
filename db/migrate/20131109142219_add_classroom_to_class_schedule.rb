class AddClassroomToClassSchedule < ActiveRecord::Migration
  def change
    add_column :class_schedules, :classroom_id, :integer
  end
end
