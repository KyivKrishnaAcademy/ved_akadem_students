class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.text :description

      t.timestamps
    end

    create_table :questionnaires_study_applications, id: false do |t|
      t.belongs_to :questionnaire
      t.belongs_to :study_application
    end
  end
end
