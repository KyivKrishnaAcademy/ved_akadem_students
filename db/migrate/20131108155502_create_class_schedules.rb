class CreateClassSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :class_schedules do |t|

      t.timestamps
    end
  end
end
