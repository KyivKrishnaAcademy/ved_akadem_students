class RemoveSpecialNoteFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :special_note, :text
  end
end
