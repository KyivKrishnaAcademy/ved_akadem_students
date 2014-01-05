require 'spec_helper'

feature "Edit person:" do
  subject { page }

  before do
    visit person_path(create_person)
    click_link "Edit"
    fill_in 'Spiritual name', with: 'AdiDasa dasa dasa anudasa'
    click_button "Update Person"
  end

  scenario { should have_content('Spiritual name: Adidasa Dasa Dasa Anudasa') }
  scenario { should have_selector('section.alert-success', text: 'Person was successfully updated.') }
end
