class AddRevisionToAttendance < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :revision, :integer, default: 1

    add_index :attendances, [:class_schedule_id, :student_profile_id], unique: true
  end
end
