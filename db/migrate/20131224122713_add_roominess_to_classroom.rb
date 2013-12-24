class AddRoominessToClassroom < ActiveRecord::Migration
  def change
    add_column :classrooms, :roominess, :integer
  end
end
