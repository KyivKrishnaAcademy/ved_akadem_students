class DropQuestionnaireFieldsFromPerson < ActiveRecord::Migration[5.0]
  def up
    remove_column :people, :education
    remove_column :people, :favorite_lectors
    remove_column :people, :friends_to_be_with
    remove_column :people, :marital_status
    remove_column :people, :work
  end

  def down
    add_column :people, :education, :string
    add_column :people, :favorite_lectors, :string
    add_column :people, :friends_to_be_with, :string
    add_column :people, :marital_status, :string
    add_column :people, :work, :string
  end
end
