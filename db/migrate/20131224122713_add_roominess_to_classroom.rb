class AddRoominessToClassroom < ActiveRecord::Migration[5.0]
  def change
    add_column :classrooms, :roominess, :integer
  end
end
