class AddTimesToClassSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :class_schedules, :start_time, :datetime
    add_column :class_schedules, :finish_time, :datetime
  end
end
