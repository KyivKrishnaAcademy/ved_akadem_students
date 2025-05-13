class AddGraduatedAtToAcademicGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :academic_groups, :graduated_at, :datetime
  end
end
