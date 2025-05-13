class AddPasswordDigestToPeople < ActiveRecord::Migration[7.2]
  def change
    add_column :people, :password_digest, :string
  end
end
