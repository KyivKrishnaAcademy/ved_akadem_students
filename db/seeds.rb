# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Person.where(email: 'admin@example.com').none?
  role = FactoryGirl.create :role, :super_admin

  FactoryGirl.create :person, email: 'admin@example.com', roles: [role], password: 'password', password_confirmation: 'password'
end
