class AddPassportToPerson < ActiveRecord::Migration
  def change
    add_column :people, :passport, :string
  end
end
