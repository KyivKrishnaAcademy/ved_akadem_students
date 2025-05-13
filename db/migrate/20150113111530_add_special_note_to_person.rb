class AddSpecialNoteToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :special_note, :text
  end
end
