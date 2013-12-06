require 'spec_helper'

feature "Edit person:" do
  before(:all) { create_person      }
  after(:all)  { Person.destroy_all }

  subject { page }

  scenario do
    visit person_path(Person.last)
    click_link "Edit"
    fill_in 'Spiritual name', with: 'AdiDasa dasa dasa anudasa'
    click_button "Update Person"
    
    should have_content('Spiritual name: Adidasa Dasa Dasa Anudasa')
    should have_selector('section.alert-success', text: 'Person was successfully updated.')
  end
end
