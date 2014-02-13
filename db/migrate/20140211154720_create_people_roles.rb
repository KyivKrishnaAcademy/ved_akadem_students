class CreatePeopleRoles < ActiveRecord::Migration
  def change
    create_table :people_roles do |t|
      t.belongs_to :person
      t.belongs_to :role
    end
  end
end
