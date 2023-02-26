class AddQuestionnairesCountToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :questionnaires_count, :integer, default: 0
  end
end
