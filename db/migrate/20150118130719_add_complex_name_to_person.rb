class AddComplexNameToPerson < ActiveRecord::Migration
  def change
    add_column :people, :complex_name, :string
  end
end
