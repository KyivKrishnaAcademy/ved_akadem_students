require 'rails_helper'

describe :home do
  Given(:person) { create(:person) }

  Given { login_as_user(person) }
  Given { page.set_rack_session(locale: :uk) }

  When  { visit '/static_pages/home' }

  context 'should have the right title' do
    Then { expect(page).to have_title("#{I18n.t :application_title} | #{I18n.t('static_pages.home.title')}") }
  end

  context 'person brief' do
    Then { expect(find('.person-brief')).to have_content(person.name)}
    And  { expect(find('.person-brief')).to have_link(I18n.t('links.edit_profile'), href: edit_person_registration_path(person)) }
  end

  it_behaves_like :study_applications, false
end
