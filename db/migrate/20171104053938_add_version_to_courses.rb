class AddVersionToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :variant, :string
  end
end
