class AddVisibleToProgram < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :visible, :boolean, default: false
  end
end
