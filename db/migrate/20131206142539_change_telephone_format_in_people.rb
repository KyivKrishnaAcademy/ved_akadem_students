class ChangeTelephoneFormatInPeople < ActiveRecord::Migration[5.0]
  def self.up
   change_column :people, :telephone, :bigint
  end

  def self.down
   change_column :people, :telephone, :integer
  end
end
