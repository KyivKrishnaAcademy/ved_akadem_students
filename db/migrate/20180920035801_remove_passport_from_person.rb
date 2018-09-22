require 'fileutils'

class RemovePassportFromPerson < ActiveRecord::Migration[5.0]
  def up
    remove_column :people, :passport, :string

    FileUtils.remove_dir(Rails.root.join('uploads', 'person', 'passport'), true)
  end

  def down
    add_column :people, :passport, :string
  end
end
