class RemoveSinceFromTeacherSpeciality < ActiveRecord::Migration
  def change
    remove_column :teacher_specialities, :since, :date
  end
end
