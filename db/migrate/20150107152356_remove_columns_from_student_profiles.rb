class RemoveColumnsFromStudentProfiles < ActiveRecord::Migration
  def change
    remove_column :student_profiles, :questionarie, :boolean
    remove_column :student_profiles, :passport_copy, :boolean
    remove_column :student_profiles, :petition, :boolean
    remove_column :student_profiles, :photos, :boolean
    remove_column :student_profiles, :folder_in_archive, :boolean
    remove_column :student_profiles, :active_student, :boolean
  end
end
