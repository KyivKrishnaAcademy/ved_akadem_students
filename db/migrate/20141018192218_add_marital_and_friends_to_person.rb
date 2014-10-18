class AddMaritalAndFriendsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :marital_status, :string
    add_column :people, :friends_to_be_with, :string
  end
end
