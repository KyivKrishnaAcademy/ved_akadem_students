class CreateGroupParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :group_participations do |t|
      t.integer :student_profile_id

      t.timestamps
    end
  end
end
