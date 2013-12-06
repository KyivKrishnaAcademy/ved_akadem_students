class ChangeTelephoneFormatInPeople < ActiveRecord::Migration
  def self.up
   change_column :people, :telephone, :bigint
  end

  def self.down
   change_column :people, :telephone, :integer
  end
end
