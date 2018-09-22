class RemoveSpiritualFieldsFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :diksha_guru, :string
    remove_column :people, :spiritual_name, :string

    add_column :people, :diploma_name, :string
    add_column :people, :favorite_lectors, :string
  end
end
