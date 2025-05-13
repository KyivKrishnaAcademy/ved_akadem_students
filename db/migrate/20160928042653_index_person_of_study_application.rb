class IndexPersonOfStudyApplication < ActiveRecord::Migration[5.0]
  def change
    add_index :study_applications, :person_id, unique: true
  end
end
