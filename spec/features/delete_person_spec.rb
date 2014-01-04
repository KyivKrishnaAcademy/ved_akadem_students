require 'spec_helper'

feature "Delete person:", js: true do
  after (:all)  { Person.destroy_all }
  before(:all)  { 2.times { create_person } }
  before(:each) { visit person_path(Person.last) }

  scenario do
    click_link "Delete"
    page.should have_selector('section.alert-success', text: 'Person record deleted!')
  end

  scenario { expect{ click_link "Delete" }.to change{Person.count}.by(-1) }
end
