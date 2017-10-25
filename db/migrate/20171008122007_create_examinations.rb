class CreateExaminations < ActiveRecord::Migration[5.0]
  def change
    create_table :examinations do |t|
      t.string :title, default: ''
      t.text :description, default: ''
      t.integer :passing_score, default: 1
      t.integer :min_result, default: 0
      t.integer :max_result, default: 1
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
