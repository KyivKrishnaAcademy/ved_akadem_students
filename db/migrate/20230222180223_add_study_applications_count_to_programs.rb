class AddStudyApplicationsCountToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :study_applications_count, :integer, default: 0
  end
end
