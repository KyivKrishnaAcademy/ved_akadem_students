class RemoveDeletedFlagFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :deleted, :boolean, default: false
  end
end
