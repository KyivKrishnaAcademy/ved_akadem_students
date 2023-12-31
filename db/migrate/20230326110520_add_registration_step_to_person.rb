class AddRegistrationStepToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :completed_registration_step, :string, default: ''
  end
end
