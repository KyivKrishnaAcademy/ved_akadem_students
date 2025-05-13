class CreateAcademicGroupSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :academic_group_schedules do |t|
      t.integer :academic_group_id
      t.integer :class_schedule_id

      t.timestamps null: false
    end
  end
end
