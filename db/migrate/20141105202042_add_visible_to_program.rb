class AddVisibleToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :visible, :boolean, default: false
  end
end
