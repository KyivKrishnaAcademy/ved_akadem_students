class RemoveProfileFillnessFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :profile_fullness, :boolean
  end
end
