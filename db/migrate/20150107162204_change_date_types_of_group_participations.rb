class ChangeDateTypesOfGroupParticipations < ActiveRecord::Migration
  def up
    change_column :group_participations, :join_date, :datetime
    change_column :group_participations, :leave_date, :datetime
  end

  def down
    change_column :group_participations, :join_date, :date
    change_column :group_participations, :leave_date, :date
  end
end
