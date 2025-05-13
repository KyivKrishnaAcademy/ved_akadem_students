class CreateJoinTableCoursesPrograms < ActiveRecord::Migration[5.0]
  def up
    create_table :courses_programs, id: false do |t|
      t.integer :course_id, null: false
      t.integer :program_id, null: false

      t.index [:course_id, :program_id], unique: true
      t.index [:program_id, :course_id]
    end
  end

  def down
    drop_table :courses_programs, if_exists: true
  end
end