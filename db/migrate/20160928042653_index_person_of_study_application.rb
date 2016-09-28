class IndexPersonOfStudyApplication < ActiveRecord::Migration
  def change
    add_index :study_applications, :person_id, unique: true
  end
end
