class DropQuestionnaireFieldsFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :education
    remove_column :people, :favorite_lectors
    remove_column :people, :friends_to_be_with
    remove_column :people, :marital_status
    remove_column :people, :work
  end
end
