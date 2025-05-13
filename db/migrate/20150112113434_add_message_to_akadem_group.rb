class AddMessageToAkademGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :akadem_groups, :message_ru, :text
    add_column :akadem_groups, :message_uk, :text
  end
end
