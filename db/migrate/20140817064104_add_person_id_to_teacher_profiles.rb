class AddPersonIdToTeacherProfiles < ActiveRecord::Migration
  def up
    add_column :teacher_profiles, :person_id, :integer
  end

  def down
    remove_column :teacher_profiles, :person_id, :integer
  end
end
