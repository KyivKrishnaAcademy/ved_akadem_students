require 'spec_helper'

describe "people/add.html.erb" do

  before { visit people_add_path }

  subject { page }

  it { should have_title("Kiev Vedic Akademy DataBase | Add New Person") }
  it { should have_selector('form.new_person') }
  it { should have_selector('label', text: "Name") }
  it { should have_selector('input#person_name') }
  it { should have_selector('input.btn') }
  it { should have_selector('label', text: "Middle name") }
  it { should have_selector('input#person_middle_name') }
  it { should have_selector('label', text: "Surname") }
  it { should have_selector('input#person_surname') }
  it { should have_selector('label', text: "Spiritual name") }
  it { should have_selector('input#person_spiritual_name') }
  it { should have_selector('label', text: "Telephone") }
  it { should have_selector('input#person_telephone') }
  it { should have_selector('label', text: "Email") }
  it { should have_selector('input#person_email') }
  it { should have_selector('label', text: "Gender") }
  it { should have_selector('select#person_gender') }
  it { should have_selector('label', text: "Birthday") }
  it { should have_selector('select#person_birthday_1i') }
  it { should have_selector('select#person_birthday_2i') }
  it { should have_selector('select#person_birthday_3i') }
  it { should have_selector('label', text: "Education and job") }
  it { should have_selector('input#person_edu_and_work') }
  it { should have_selector('label', text: "Emergency contact") }
  it { should have_selector('input#person_emergency_contact') }
  xit { should have_selector('label', text: "Photo") }
  xit { should have_selector('input#person_photo') }

end
