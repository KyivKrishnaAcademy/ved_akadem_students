class RemoveSinceFromTeacherSpeciality < ActiveRecord::Migration[5.0]
  def change
    remove_column :teacher_specialities, :since, :date
  end
end
