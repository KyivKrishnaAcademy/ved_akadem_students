class AddColumnsToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :class_schedule_id, :integer
    add_column :attendances, :student_profile_id, :integer
  end
end
