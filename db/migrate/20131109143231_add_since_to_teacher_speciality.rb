class AddSinceToTeacherSpeciality < ActiveRecord::Migration[5.0]
  def change
    add_column :teacher_specialities, :since, :date
  end
end
