class CreateStudentProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :student_profiles do |t|
      t.integer :person_id

      t.timestamps
    end
  end
end
