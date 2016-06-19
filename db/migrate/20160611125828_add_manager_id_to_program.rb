class AddManagerIdToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :manager_id, :integer
  end
end
