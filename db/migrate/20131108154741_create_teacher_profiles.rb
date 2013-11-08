class CreateTeacherProfiles < ActiveRecord::Migration
  def change
    create_table :teacher_profiles do |t|

      t.timestamps
    end
  end
end
