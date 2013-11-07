class AddColumnsToStudentProfiles < ActiveRecord::Migration
  def change
    add_column :student_profiles, :questionarie, :boolean
    add_column :student_profiles, :passport_copy, :boolean
    add_column :student_profiles, :petition, :boolean
    add_column :student_profiles, :photos, :boolean
    add_column :student_profiles, :folder_in_archive, :string
    add_column :student_profiles, :active_student, :boolean
  end
end
