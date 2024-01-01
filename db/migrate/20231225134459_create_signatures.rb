class CreateSignatures < ActiveRecord::Migration[5.0]
  def change
    create_table :signatures do |t|
      t.string :name
      t.string :file

      t.timestamps
    end
    add_index :signatures, :name, unique: true
  end
end
