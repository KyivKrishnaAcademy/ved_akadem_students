class AddIndexToPeople < ActiveRecord::Migration[5.0]
  def change
    add_index :people, :email, unique: true
  end
end
