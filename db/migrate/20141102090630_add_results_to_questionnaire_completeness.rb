class AddResultsToQuestionnaireCompleteness < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaire_completenesses, :result, :text
  end
end
