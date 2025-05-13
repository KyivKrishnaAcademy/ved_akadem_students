class AddTitleToClassroom < ActiveRecord::Migration[5.0]
  def change
    add_column :classrooms, :title, :string
  end
end
