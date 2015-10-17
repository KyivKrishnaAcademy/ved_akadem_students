class DeviseTokenAuthChangePeople < ActiveRecord::Migration
  def up
    add_column :people, :provider, :string, null: false, default: 'email'
    add_column :people, :uid, :string, null: false, default: ''
    add_column :people, :tokens, :jsonb, null: false, default: '{}'

    Person.unscoped.each { |p| p.update_column(:uid, p.email) }

    add_index :people, [:uid, :provider], unique: true
    add_index :people, :reset_password_token, unique: true
  end

  def down
    remove_index :people, [:uid, :provider]
    remove_index :people, :reset_password_token

    remove_column :people, :provider
    remove_column :people, :uid
    remove_column :people, :tokens
  end
end
