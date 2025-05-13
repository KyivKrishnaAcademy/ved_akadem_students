class LocalizeQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    rename_column :questionnaires, :title,       :title_uk
    rename_column :questionnaires, :description, :description_uk

    add_column    :questionnaires, :title_ru,       :string
    add_column    :questionnaires, :description_ru, :text
  end
end
