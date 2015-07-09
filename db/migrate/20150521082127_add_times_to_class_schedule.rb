class AddTimesToClassSchedule < ActiveRecord::Migration
  def change
    add_column :class_schedules, :start_time, :datetime
    add_column :class_schedules, :finish_time, :datetime
  end
end
