class CreateTeacherSpecialities < ActiveRecord::Migration
  def change
    create_table :teacher_specialities do |t|

      t.timestamps
    end
  end
end
