class AddColumnsToClassroom < ActiveRecord::Migration
  def change
    add_column :classrooms, :location, :string
    add_column :classrooms, :description, :string
  end
end
