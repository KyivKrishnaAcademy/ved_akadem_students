require 'rails_helper'

describe 'people/show.html.haml' do
  Given { @p = create :person }
  When  do
    login_as_user(@p)
    visit person_path(@p)
  end

  Then { expect(page).to     have_title(full_title(complex_name(@p, :t))) }
  Then { expect(page).not_to have_title(full_title(complex_name(@p    ))) }

  Then { expect(find('body')).to have_selector('h1', text: complex_name(@p)) }

  Then { expect(find('body')).to have_text("Name: #{@p.name}") }
  Then { expect(find('body')).to have_text("Surname: #{@p.surname}") }
  Then { expect(find('body')).to have_text("Middle name: #{@p.middle_name}") }
  Then { expect(find('body')).to have_text("Spiritual name: #{@p.spiritual_name}") }
  Then { expect(find('body')).to have_text("Telephone 1: #{@p.telephones.first.phone}") }
  Then { expect(find('body')).to have_text("Email: #{@p.email}") }
  Then { expect(find('body')).to have_text("Emergency contact: #{@p.emergency_contact}") }
  Then { expect(find('body')).to have_text("Education, hobby, job: #{@p.edu_and_work}") }
  Then { expect(find('body')).to have_text(/Gender: (Male|Female)/) }
  Then { expect(find('body')).to have_text("Birthday: #{@p.birthday.to_s}") }

  Then { expect(find('body')).to have_link('Delete', href: person_path(@p)     ) }
  Then { expect(find('body')).to have_link('Edit'  , href: edit_person_path(@p)) }
end
