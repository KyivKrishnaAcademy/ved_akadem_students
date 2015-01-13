class AddSpecialNoteToPerson < ActiveRecord::Migration
  def change
    add_column :people, :special_note, :text
  end
end
