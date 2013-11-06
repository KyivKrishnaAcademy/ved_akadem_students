class CreateGroupParticipations < ActiveRecord::Migration
  def change
    create_table :group_participations do |t|
      t.integer :student_profile_id

      t.timestamps
    end
  end
end
