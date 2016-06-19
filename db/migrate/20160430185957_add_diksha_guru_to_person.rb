class AddDikshaGuruToPerson < ActiveRecord::Migration
  def change
    add_column :people, :diksha_guru, :string
  end
end
