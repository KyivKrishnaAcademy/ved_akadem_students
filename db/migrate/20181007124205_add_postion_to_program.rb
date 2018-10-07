class AddPostionToProgram < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :position, :integer
  end
end
