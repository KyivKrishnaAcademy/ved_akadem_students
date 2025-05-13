class CreateStudyApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :study_applications do |t|
      t.integer :person_id
      t.integer :program_id

      t.timestamps
    end
  end
end
