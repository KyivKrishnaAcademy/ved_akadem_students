# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

FactoryGirl.create(:person, :admin) if Person.where(email: 'admin@example.com').none?

Rake::Task['akadem:create_programs'].invoke
Rake::Task['akadem:create_questionnaires'].invoke
