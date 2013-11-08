class AddColumnsToTeacherProfile < ActiveRecord::Migration
  def change
    add_column :teacher_profiles, :description, :string
  end
end
