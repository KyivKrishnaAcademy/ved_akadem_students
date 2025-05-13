class AddKindToQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :kind, :string
  end
end
