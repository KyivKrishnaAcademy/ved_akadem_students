class RemoveDateFromClassSchedule < ActiveRecord::Migration[5.0]
  def change
    remove_column :class_schedules, :date, :date
  end
end
