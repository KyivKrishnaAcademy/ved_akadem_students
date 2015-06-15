class AddSubjectToClassSchedule < ActiveRecord::Migration
  def change
    add_column :class_schedules, :subject, :string
  end
end
