class AddPassportToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :passport, :string
  end
end
