require 'rails_helper'

describe 'Add person:' do
  When  { login_as_admin }
  When  { visit new_person_path }

  describe :link_in_flash do
    When { @person_built = fill_person_data(gender: 'Жіноча') }
    When { click_button 'Створити Person' }
    When { @person = Person.find_by(email: @person_built.email) }

    Then { expect(find('.alert-dismissible')).to have_link(@person.complex_name, href: person_path(@person)) }
  end

  describe 'simple (no student, no teacher)' do
    describe 'adds Person' do
      When  { fill_person_data(gender: 'Жіноча') }

      Then  { expect { click_button 'Створити Person' }.to change{Person.count}.by(1) }
      And   { expect(page).to have_selector('.alert-success') }
    end

    describe 'do not adds person' do
      When  { fill_person_data email: '3322' }

      Then  { expect { click_button 'Створити Person' }.not_to change{Person.count} }
      And   { expect(page).to have_selector('.alert-danger') }
    end
  end

  def fill_person_data(p = {})
    pf = build_stubbed(:person, p)
    fill_in 'phone'                 , with: pf.telephones.first.phone
    fill_in 'person_spiritual_name' , with: pf.spiritual_name
    fill_in 'person_name'           , with: pf.name
    fill_in 'person_middle_name'    , with: pf.middle_name
    fill_in 'person_surname'        , with: pf.surname
    fill_in 'person_email'          , with: pf.email
    fill_in 'person_education'      , with: pf.education
    fill_in 'person_work'           , with: pf.work
    fill_in 'person[birthday]'      , with: (p[:birthday] || '30.05.1984')
    select  (p[:gender] || 'Чоловіча').to_s, from: 'person_gender'
    select  (p[:marital_status] || 'одружений/заміжня').to_s, from: 'person_marital_status'
    pf
  end
end
