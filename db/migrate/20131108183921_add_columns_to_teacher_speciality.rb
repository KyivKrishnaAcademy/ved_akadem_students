class AddColumnsToTeacherSpeciality < ActiveRecord::Migration[5.0]
  def change
    add_column :teacher_specialities, :teacher_profile_id, :integer
    add_column :teacher_specialities, :course_id, :integer
  end
end
