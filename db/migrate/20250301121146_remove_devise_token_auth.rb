class RemoveDeviseTokenAuth < ActiveRecord::Migration[5.2]
  def change
    remove_index :people, :username if index_exists?(:people, :username)
    remove_column :people, :username if column_exists?(:people, :username)
    remove_column :people, :encrypted_password if column_exists?(:people, :encrypted_password)
  end
end