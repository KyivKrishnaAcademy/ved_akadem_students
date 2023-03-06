class AddSchedulesCountToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :class_schedules_count, :integer, default: 0
  end
end
