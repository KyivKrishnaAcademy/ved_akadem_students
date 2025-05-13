class CreateQuestionnaireCompletenesses < ActiveRecord::Migration[5.0]
  def change
    create_table :questionnaire_completenesses do |t|
      t.integer :questionnaire_id
      t.integer :person_id
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
