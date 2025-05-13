class AddFakeEmailToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :fake_email, :boolean, default: false
  end
end
