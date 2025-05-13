class AddColumsToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :middle_name, :string
    add_column :people, :surname, :string
    add_column :people, :spiritual_name, :string
    add_column :people, :telephone, :integer
    add_column :people, :email, :string
    add_column :people, :gender, :boolean
    add_column :people, :birthday, :date
    add_column :people, :emergency_contact, :string
    add_column :people, :photo, :text
    add_column :people, :profile_fullness, :boolean
    add_column :people, :edu_and_work, :text
  end
end
