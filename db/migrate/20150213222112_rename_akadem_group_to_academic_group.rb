class RenameAkademGroupToAcademicGroup < ActiveRecord::Migration
  def change
    rename_table :akadem_groups, :academic_groups
    rename_column :class_schedules, :akadem_group_id, :academic_group_id
    rename_column :group_participations, :akadem_group_id, :academic_group_id
  end
end
