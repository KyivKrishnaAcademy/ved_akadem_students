class AddColumnsToAttendance < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :class_schedule_id, :integer
    add_column :attendances, :student_profile_id, :integer
  end
end
