class AddTitleToClassroom < ActiveRecord::Migration
  def change
    add_column :classrooms, :title, :string
  end
end
