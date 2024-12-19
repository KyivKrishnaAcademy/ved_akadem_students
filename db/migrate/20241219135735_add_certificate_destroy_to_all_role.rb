class AddCertificateDestroyToAllRole < ActiveRecord::Migration[5.0]
  class Role < ApplicationRecord
    self.table_name = 'roles' # Ensuring we work with the right table
  end

  def up
    role = Role.find_by(name: 'all')
    if role && role.activities.is_a?(Array)
      role.activities |= ['certificate:destroy'] # Avoiding duplication
      role.save!
    end
  end

  def down
    role = Role.find_by(name: 'all')
    if role && role.activities.is_a?(Array)
      role.activities -= ['certificate:destroy']
      role.save!
    end
  end
end