require 'spec_helper'

feature "Delete person:", js: true do
  before(:all) { create_person      }
  after(:all)  { Person.destroy_all }

  scenario do
    visit person_path(Person.last)
    expect{ click_link "Delete" }.to change{Person.count}.by(-1)
  end
end
