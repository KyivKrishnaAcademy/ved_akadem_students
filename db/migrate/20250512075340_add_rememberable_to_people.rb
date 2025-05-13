class AddRememberableToPeople < ActiveRecord::Migration[7.2]
  def change
    add_column :people, :remember_created_at, :datetime
  end
end
