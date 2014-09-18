class ReplaceEduAndWorkInPerson < ActiveRecord::Migration
  def change
    add_column    :people, :education   , :string
    add_column    :people, :work        , :string
    remove_column :people, :edu_and_work, :string
  end
end
