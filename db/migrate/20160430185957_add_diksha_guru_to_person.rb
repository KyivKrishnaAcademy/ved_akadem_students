class AddDikshaGuruToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :diksha_guru, :string
  end
end
