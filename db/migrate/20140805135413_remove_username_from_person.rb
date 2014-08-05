class RemoveUsernameFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :username, :string
  end
end
