class CreateUnsubscribes < ActiveRecord::Migration[5.0]
  def change
    create_table :unsubscribes do |t|
      t.string :email
      t.string :code
      t.string :kind
      t.references :person, foreign_key: true

      t.timestamps
    end

    add_index :unsubscribes, [:email, :code], unique: true
  end
end
