class CreateJoinTableCoursesPrograms < ActiveRecord::Migration[5.0]
  def change
    create_join_table :courses, :programs do |t|
      t.index [:course_id, :program_id]
      t.index [:program_id, :course_id]
    end
  end
end
