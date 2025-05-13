class AddRuleToQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :rule, :text
  end
end
