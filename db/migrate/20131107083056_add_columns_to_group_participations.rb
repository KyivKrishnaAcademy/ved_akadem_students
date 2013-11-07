class AddColumnsToGroupParticipations < ActiveRecord::Migration
  def change
    add_column :group_participations, :akadem_group_id, :integer
    add_column :group_participations, :join_date, :date
    add_column :group_participations, :leave_date, :date
  end
end
