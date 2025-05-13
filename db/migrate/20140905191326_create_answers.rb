class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :person_id
      t.text    :data

      t.timestamps
    end
  end
end
