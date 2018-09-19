class AddVerifiedToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :verified, :boolean, default: false
  end
end
