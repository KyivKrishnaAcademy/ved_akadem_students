class DropVerifiedFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :verified, :boolean, default: false
  end
end
