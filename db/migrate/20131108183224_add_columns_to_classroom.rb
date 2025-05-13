class AddColumnsToClassroom < ActiveRecord::Migration[5.0]
  def change
    add_column :classrooms, :location, :string
    add_column :classrooms, :description, :string
  end
end
