class CreateQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    create_table :questionnaires do |t|
      t.text :description
      t.string :title

      t.timestamps
    end

    create_table :programs_questionnaires, id: false do |t|
      t.belongs_to :questionnaire
      t.belongs_to :program
    end
  end
end
