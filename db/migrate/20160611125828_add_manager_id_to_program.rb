class AddManagerIdToProgram < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :manager_id, :integer
  end
end
