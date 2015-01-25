require 'rails_helper'

describe 'people/show.html.haml' do
  Given { @p = create :person, :admin }
  When  do
    login_as_user(@p)
    visit person_path(@p)
  end

  Then { expect(page).to     have_title(full_title(complex_name(@p, :t))) }
  Then { expect(page).not_to have_title(full_title(complex_name(@p    ))) }

  Then { expect(find('body')).to have_selector('h1', text: complex_name(@p)) }

  Then { expect(find('body')).to have_text("Telephone 1: #{@p.telephones.first.phone}") }
  Then { expect(find('body')).to have_text("Email: #{@p.email}") }
  Then { expect(find('body')).to have_text("Emergency contact: #{@p.emergency_contact}") }
  Then { expect(find('body')).to have_text("Education: #{@p.education}") }
  Then { expect(find('body')).to have_text("Work: #{@p.work}") }
  Then { expect(find('body')).to have_text(/Gender: (Male|Female)/) }
  Then { expect(find('body')).to have_text("Birthday: #{@p.birthday.to_s}") }

  Then { expect(find('body')).to have_link(I18n.t('links.delete'), href: person_path(@p)) }
  Then { expect(find('body')).to have_link(I18n.t('links.edit')  , href: edit_person_path(@p)) }
end
