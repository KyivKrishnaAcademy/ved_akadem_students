class RemoveTelephoneFromPerson < ActiveRecord::Migration
  def up
    remove_column :people, :telephone
  end

  def down
    add_column :people, :telephone, :bigint
  end
end
