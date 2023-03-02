class AddPrimaryKeyToProgramsQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    add_column :programs_questionnaires, :id, :primary_key

    add_index(
      :programs_questionnaires,
      [:program_id, :questionnaire_id],
      unique: true,
      name: 'index_programs_questionnaires_on_p_and_q'
    )
  end
end
