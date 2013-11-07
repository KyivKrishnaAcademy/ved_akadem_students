class AddColumnsToAkademGroups < ActiveRecord::Migration
  def change
    add_column :akadem_groups, :group_description, :string
    add_column :akadem_groups, :establ_date, :date
  end
end
