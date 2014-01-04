require 'spec_helper'

feature "Edit person:" do
  after(:all)  { Person.destroy_all }

  let(:p) { create_person }

  subject { page }

  before(:each) do
    visit person_path(p)
    click_link "Edit"
    fill_in 'Spiritual name', with: 'AdiDasa dasa dasa anudasa'
    click_button "Update Person"
  end

  scenario { should have_content('Spiritual name: Adidasa Dasa Dasa Anudasa') }
  scenario { should have_selector('section.alert-success', text: 'Person was successfully updated.') }
end
