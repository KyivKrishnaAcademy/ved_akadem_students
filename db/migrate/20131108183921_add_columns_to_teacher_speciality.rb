class AddColumnsToTeacherSpeciality < ActiveRecord::Migration
  def change
    add_column :teacher_specialities, :teacher_profile_id, :integer
    add_column :teacher_specialities, :course_id, :integer
  end
end
