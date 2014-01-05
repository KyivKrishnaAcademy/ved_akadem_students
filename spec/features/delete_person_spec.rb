require 'spec_helper'

feature "Delete person:", js: true do
  before { visit person_path(create_person) }

  scenario do
    click_link "Delete"
    page.should have_selector('section.alert-success', text: 'Person record deleted!')
  end

  scenario { expect{ click_link "Delete" }.to change{Person.count}.by(-1) }
end
