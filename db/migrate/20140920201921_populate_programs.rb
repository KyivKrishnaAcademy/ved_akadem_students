class PopulatePrograms < ActiveRecord::Migration
  def up
    Program.destroy_all

    Rake::Task['akadem:create_programs'].invoke
  end
end
