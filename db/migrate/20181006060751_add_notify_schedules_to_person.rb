class AddNotifySchedulesToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :notify_schedules, :boolean, default: true
  end
end
