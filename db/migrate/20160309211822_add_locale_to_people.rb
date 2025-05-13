class AddLocaleToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :locale, :string, limit: 2, default: :uk
  end
end
