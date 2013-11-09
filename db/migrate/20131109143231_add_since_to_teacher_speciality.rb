class AddSinceToTeacherSpeciality < ActiveRecord::Migration
  def change
    add_column :teacher_specialities, :since, :date
  end
end
