class AddKindToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :kind, :string
  end
end
