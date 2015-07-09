class ChangeRoominessOfClassroom < ActiveRecord::Migration
  def up
    change_column :classrooms, :roominess, :integer, default: 0
  end

  def down
    change_column :classrooms, :roominess, :integer, default: nil
  end
end
