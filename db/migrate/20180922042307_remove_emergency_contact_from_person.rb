class RemoveEmergencyContactFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :emergency_contact, :string
  end
end
