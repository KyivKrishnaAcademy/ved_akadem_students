class AddDeviseToPeople < ActiveRecord::Migration[5.0]
  def self.up
    change_table(:people) do |t|
      t.string :username
      t.string :encrypted_password
    end

    add_index :people, :username, unique: true
  end

  def self.down
    remove_index  :people, :username
    remove_column :people, :username
    remove_column :people, :encrypted_password
  end
end
