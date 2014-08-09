require 'spec_helper'

describe 'Signing' do
  describe 'Sign in' do
    Given { create :person, email: 'test@example.com', password: 'password', password_confirmation: 'password' }

    When do
      visit root_path
      fill_in 'person_email', with: 'test@example.com'
      fill_in 'person_password', with: 'password'
      click_button I18n.t('devise.links.sign_in')
    end

    Then { find('.alert-notice').should have_content(I18n.t('devise.sessions.signed_in')) }
  end

  describe 'Sign Up' do
    When do
      visit new_person_registration_path
      fill_in 'person_email', with: 'test@example.com'
      fill_in 'person_password', with: 'password'
      fill_in 'person_password_confirmation', with: 'password'
      fill_in 'person_spiritual_name', with: 'Adi dasa das'
      fill_in 'person_name', with: 'Vasyl'
      fill_in 'person_middle_name', with: 'Alexovich'
      fill_in 'person_surname', with: 'Mitrofanov'
      fill_in 'person_telephone', with: '380112223344'
      select  'Male', from: 'person_gender'
      select  '2012', from: 'person_birthday_1i'
      select  'May', from: 'person_birthday_2i'
      select  '20', from: 'person_birthday_3i'
      fill_in 'person_edu_and_work', with: 'NTUU KPI'
      fill_in 'person_emergency_contact', with: 'Krishna'
      click_button I18n.t('devise.links.sign_up')
    end

    Then { find('.alert-notice').should have_content(I18n.t('devise.registrations.signed_up'))}
  end
end
