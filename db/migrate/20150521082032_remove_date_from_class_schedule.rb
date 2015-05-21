class RemoveDateFromClassSchedule < ActiveRecord::Migration
  def change
    remove_column :class_schedules, :date, :date
  end
end
