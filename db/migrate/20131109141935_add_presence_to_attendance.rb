class AddPresenceToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :presence, :boolean
  end
end
