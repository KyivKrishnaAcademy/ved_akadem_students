class ReplaceEduAndWorkInPerson < ActiveRecord::Migration
  def change
    add_column    :people, :education   , :text
    add_column    :people, :work        , :text
    remove_column :people, :edu_and_work, :text
  end
end
