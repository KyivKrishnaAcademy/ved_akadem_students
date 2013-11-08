class AddColumnsToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :name, :string
    add_column :courses, :description, :string
  end
end
