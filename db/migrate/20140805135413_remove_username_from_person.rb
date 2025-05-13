class RemoveUsernameFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :username, :string
  end
end
