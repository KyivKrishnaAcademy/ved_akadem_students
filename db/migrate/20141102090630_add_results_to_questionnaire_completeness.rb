class AddResultsToQuestionnaireCompleteness < ActiveRecord::Migration
  def change
    add_column :questionnaire_completenesses, :result, :text
  end
end
