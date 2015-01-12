class AddMessageToAkademGroup < ActiveRecord::Migration
  def change
    add_column :akadem_groups, :message_ru, :text
    add_column :akadem_groups, :message_uk, :text
  end
end
