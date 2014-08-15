require 'spec_helper'

describe 'people/new.html.erb' do
  Given { @p = create :person }
  When  do
    login_as_user(@p)
    visit person_path(@p)
  end

  Then { page.should     have_title(full_title(complex_name(@p, :t))) }
  Then { page.should_not have_title(full_title(complex_name(@p    ))) }

  Then { find('body').should have_selector('h1', text: complex_name(@p)) }

  Then { find('body').should have_text("Name: #{@p.name}") }
  Then { find('body').should have_text("Surname: #{@p.surname}") }
  Then { find('body').should have_text("Middle name: #{@p.middle_name}") }
  Then { find('body').should have_text("Spiritual name: #{@p.spiritual_name}") }
  Then { find('body').should have_text("Telephone: #{@p.telephone}") }
  Then { find('body').should have_text("Email: #{@p.email}") }
  Then { find('body').should have_text("Emergency contact: #{@p.emergency_contact}") }
  Then { find('body').should have_text("Education, hobby, job: #{@p.edu_and_work}") }
  Then { find('body').should have_text(/Gender: (Male|Female)/) }
  Then { find('body').should have_text("Birthday: #{@p.birthday.to_s}") }

  Then { find('body').should have_link('Delete', href: person_path(@p)     ) }
  Then { find('body').should have_link('Edit'  , href: edit_person_path(@p)) }
end
