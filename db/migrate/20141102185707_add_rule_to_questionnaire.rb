class AddRuleToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :rule, :text
  end
end
