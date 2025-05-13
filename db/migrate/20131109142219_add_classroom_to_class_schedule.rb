class AddClassroomToClassSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :class_schedules, :classroom_id, :integer
  end
end
