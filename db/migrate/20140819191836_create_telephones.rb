class CreateTelephones < ActiveRecord::Migration[5.0]
  def change
    create_table :telephones do |t|
      t.integer :person_id
      t.string  :phone
      t.timestamps
    end
  end
end
