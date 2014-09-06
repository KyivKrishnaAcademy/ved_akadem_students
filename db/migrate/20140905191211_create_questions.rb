class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :questionnaire_id
      t.string  :format
      t.text    :data

      t.timestamps
    end
  end
end
