class CreateTelephones < ActiveRecord::Migration
  def change
    create_table :telephones do |t|
      t.integer :person_id
      t.string  :phone
      t.timestamps
    end
  end
end
