class RemoveProfileFillnessFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :profile_fullness, :boolean
  end
end
