class RemoveTimestampsFromGroupParticipations < ActiveRecord::Migration[5.0]
  def change
    remove_column :group_participations, :created_at, :datetime
    remove_column :group_participations, :updated_at, :datetime
  end
end
