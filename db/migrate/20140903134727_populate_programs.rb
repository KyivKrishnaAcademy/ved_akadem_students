class PopulatePrograms < ActiveRecord::Migration
  def up
    Rake::Task['akadem:create_programs'].invoke
  end
end
