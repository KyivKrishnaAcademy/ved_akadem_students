class AddAdministratorsToAkademGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :akadem_groups, :praepostor_id, :integer
    add_column :akadem_groups, :curator_id, :integer
    add_column :akadem_groups, :administrator_id, :integer
  end
end
