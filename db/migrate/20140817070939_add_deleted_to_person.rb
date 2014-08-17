class AddDeletedToPerson < ActiveRecord::Migration
  def up
    add_column :people, :deleted, :boolean, default: false
  end

  def down
    remove_column :people, :deleted, :boolean, default: false
  end
end
