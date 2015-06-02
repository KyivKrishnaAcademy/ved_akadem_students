class ChangeGroupNameToTitleForAcademicGroup < ActiveRecord::Migration
  def change
    rename_column :academic_groups, :group_name, :title
  end
end
