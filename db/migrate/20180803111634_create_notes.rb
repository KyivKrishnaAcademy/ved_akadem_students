class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.references :person
      t.date :date
      t.text :message

      t.timestamps
    end
  end
end
