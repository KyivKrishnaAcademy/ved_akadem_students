class CreateExaminationResults < ActiveRecord::Migration[5.0]
  def change
    create_table :examination_results do |t|
      t.references :examination, foreign_key: true
      t.references :student_profile, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
