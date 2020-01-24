class AddSpamComplainToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :spam_complain, :boolean, default: false
  end
end
