class AddComplexNameToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :complex_name, :string
  end
end
