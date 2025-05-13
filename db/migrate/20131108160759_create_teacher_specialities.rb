class CreateTeacherSpecialities < ActiveRecord::Migration[5.0]
  def change
    create_table :teacher_specialities do |t|

      t.timestamps
    end
  end
end
