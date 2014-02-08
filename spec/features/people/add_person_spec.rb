require 'spec_helper'

feature "Add person:" do
  before do
    create_person username: 'test', password: 'password', password_confirmation: 'password'
    visit new_person_session_path
    fill_in 'person_username', with: 'test'
    fill_in 'person_password', with: 'password'
    click_button 'Sign in'
    visit new_person_path
  end

  let(:attr_name)  { :telephone }
  let(:locator)    { "#{complex_name(the_m).downcase.titleize}" }
  let(:fill_right) { fill_person_data gender: 'Female'  }
  let(:model)      { Person }

  it_behaves_like :link_in_flash

  describe "simple (no student, no teacher)" do
    let(:fill_wrong) { fill_person_data telephone: '3322' }

    it_behaves_like :adds_model
    it_behaves_like :not_adds_model
  end

  describe "student" do
    scenario { pending "to be written" }
  end

  describe "teacher" do
    scenario { pending "to be written" }
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
