class AddFakeEmailToPerson < ActiveRecord::Migration
  def change
    add_column :people, :fake_email, :boolean, default: false
  end
end
