require 'spec_helper'

describe "people/new.html.erb" do
  before do
    @p = create_person
    visit person_path(@p)
  end

  after(:all) { Person.destroy_all }

  subject { page }

  it { should     have_title(full_title(complex_name(@p, :t))) }
  it { should_not have_title(full_title(complex_name(@p    ))) }

  it { should have_selector('h1', text: complex_name(@p)) }

  it { should have_text("Name: #{@p.name}") }
  it { should have_text("Surname: #{@p.surname}") }
  it { should have_text("Middle name: #{@p.middle_name}") }
  it { should have_text("Spiritual name: #{@p.spiritual_name}") }
  it { should have_text("Telephone: #{@p.telephone}") }
  it { should have_text("Email: #{@p.email}") }
  it { should have_text("Emergency contact: #{@p.emergency_contact}") }
  it { should have_text("Education, hobby, job: #{@p.edu_and_work}") }
  it { should have_text(/Gender: (Male|Female)/) }
  it { should have_text("Birthday: #{@p.birthday.to_s}") }

  it { should have_link('Delete') }
  it { should have_link('Edit'  ) }
end