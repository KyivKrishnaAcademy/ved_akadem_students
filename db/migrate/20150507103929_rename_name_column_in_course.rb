class RenameNameColumnInCourse < ActiveRecord::Migration[5.0]
  def change
    rename_column :courses, :name, :title
  end
end
