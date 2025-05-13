class AddSubjectToClassSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :class_schedules, :subject, :string
  end
end
