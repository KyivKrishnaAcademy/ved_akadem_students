require 'spec_helper'

feature "Add person:" do

  before(:each) { visit new_person_path }
  after(:all)   { Person.destroy_all    }

  scenario "simple (no student, no teacher) added successfully with right field" do
    fill_person_data gender: 'Female'

    expect { click_button "Create Person" }.to change{Person.count}.by(1)
    expect(page).to have_selector('section.alert-success')
  end

  scenario "simple (no student, no teacher) failed to add with wrong fields" do
    fill_person_data telephone: '3322'

    expect { click_button "Create Person" }.not_to change{Person.count}.by(1)
    expect(page).to have_selector('section#error_explanation')
  end

  scenario "student" do
    pending "to be written"
  end

  scenario "teacher" do
    pending "to be written"
  end

  scenario "flash message contains link to person#show on success" do
    person              = fill_person_data
    person_complex_name = "#{complex_name(person).downcase.titleize}"

    expect { click_button "Create Person" }.to change{Person.count}.by(1)
    expect(page).to have_selector('section.alert-success a', text: person_complex_name)
    click_link person_complex_name
    expect(page).to have_selector('h1', text: person_complex_name)
  end

  def fill_person_data p={}
    pf = get_person(p)
    fill_in 'person_telephone'      , with: (pf.telephone      )
    fill_in 'person_spiritual_name' , with: (pf.spiritual_name )
    fill_in 'person_name'           , with: (pf.name           )
    fill_in 'person_middle_name'    , with: (pf.middle_name    )
    fill_in 'person_surname'        , with: (pf.surname        )
    fill_in 'person_email'          , with: (pf.email          )
    fill_in 'person_edu_and_work'   , with: (pf.edu_and_work   )
    select  (p[:gender]     ||'Male').to_s, from: 'person_gender'
    select  (p[:birthday_1i]||'1984').to_s, from: 'person_birthday_1i'
    select  (p[:birthday_2i]||'May' ).to_s, from: 'person_birthday_2i'
    select  (p[:birthday_3i]||'30'  ).to_s, from: 'person_birthday_3i'
    pf
  end
end