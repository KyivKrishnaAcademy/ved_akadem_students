class AddDeletedToPerson < ActiveRecord::Migration[5.0]
  def up
    add_column :people, :deleted, :boolean, default: false
  end

  def down
    remove_column :people, :deleted, :boolean, default: false
  end
end
