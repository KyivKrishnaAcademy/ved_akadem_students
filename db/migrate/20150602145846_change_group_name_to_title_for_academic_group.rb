class ChangeGroupNameToTitleForAcademicGroup < ActiveRecord::Migration[5.0]
  def change
    rename_column :academic_groups, :group_name, :title
  end
end
