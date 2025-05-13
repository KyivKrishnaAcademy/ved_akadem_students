class AddColumnsToTeacherProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :teacher_profiles, :description, :string
  end
end
