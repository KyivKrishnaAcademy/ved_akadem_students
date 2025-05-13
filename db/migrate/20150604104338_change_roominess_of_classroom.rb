class ChangeRoominessOfClassroom < ActiveRecord::Migration[5.0]
  def up
    change_column :classrooms, :roominess, :integer, default: 0
  end

  def down
    change_column :classrooms, :roominess, :integer, default: nil
  end
end
