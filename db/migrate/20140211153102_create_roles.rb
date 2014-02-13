class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :activities, array: true, length: 40, using: 'gin', default: '{}'
      t.string :name, limit: 30, using: 'gin'

      t.timestamps
    end
  end
end
