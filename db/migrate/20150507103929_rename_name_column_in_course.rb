class RenameNameColumnInCourse < ActiveRecord::Migration
  def change
    rename_column :courses, :name, :title
  end
end
