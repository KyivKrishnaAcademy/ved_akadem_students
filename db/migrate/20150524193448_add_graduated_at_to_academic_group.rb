class AddGraduatedAtToAcademicGroup < ActiveRecord::Migration
  def change
    add_column :academic_groups, :graduated_at, :datetime
  end
end
