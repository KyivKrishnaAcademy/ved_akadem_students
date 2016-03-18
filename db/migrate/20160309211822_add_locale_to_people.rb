class AddLocaleToPeople < ActiveRecord::Migration
  def change
    add_column :people, :locale, :string, limit: 2, default: :uk
  end
end
