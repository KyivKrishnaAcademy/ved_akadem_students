require 'spec_helper'

feature "Add person:" do
  scenario "simple (no student, no teacher) added successfully with right field" do
    visit people_add_path
    fill_person_data

    expect { click_button "Add person" }.to change{Person.count}.by(1)
    expect(page).to have_selector('section.alert-success')
  end

  scenario "simple (no student, no teacher) failed to add with wrong fields" do
    visit people_add_path
    fill_person_data telephone: '3322'

    expect { click_button "Add person" }.not_to change{Person.count}.by(1)
    expect(page).to have_selector('section#error_explanation')
  end

  scenario "student" do
    pending "to be written"
  end

  scenario "teacher" do
    pending "to be written"
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
  end
end