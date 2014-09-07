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
      fill_in 'person_telephones_attributes_0_phone', with: '380112223344'
      select  'Male', from: 'person_gender'
      select  '1985', from: 'person_birthday_1i'
      select  'May', from: 'person_birthday_2i'
      select  '20', from: 'person_birthday_3i'
      fill_in 'person_edu_and_work', with: 'NTUU KPI'
      fill_in 'person_emergency_contact', with: 'Krishna'
    end

    describe 'should signup without photo and passport' do
      When { click_button I18n.t('devise.links.sign_up') }

      Then { find('.alert-notice').should have_content(I18n.t('devise.registrations.signed_up'))}
      And  { page.should have_css('.person-brief') }
    end

    describe 'should signup with photo' do
      When do
        attach_file 'person[photo]', "#{Rails.root}/spec/fixtures/150x200.png"
        click_button I18n.t('devise.links.sign_up')
      end

      describe 'should show flash' do
        Then { find('.alert-notice').should have_content(I18n.t('devise.registrations.signed_up'))}
      end

      describe 'should direct to crop path' do
        Then { find('h1').should have_content('crop image') }
      end
    end

    describe 'should signup with passport' do
      When do
        attach_file 'person[passport]', "#{Rails.root}/spec/fixtures/150x200.png"
        click_button I18n.t('devise.links.sign_up')
      end

      describe 'should show flash' do
        Then { find('.alert-notice').should have_content(I18n.t('devise.registrations.signed_up'))}
      end

      describe 'should show passport image' do
        When { visit '/edit' }

        Then  { find('.form-inputs').should have_link('Show passport') }
      end
    end
  end

  describe 'Edit' do
    context 'with photo' do
      Given { @person = create :person, :with_photo }
      When  { login_as_user(@person) }
      When  { visit edit_person_registration_path(@person) }

      Then  { find('.form-inputs img')['src'].should have_content("/people/show_photo/standart/#{@person.id}") }
    end

    context 'without photo' do
      Given { @person = create :person }
      When  { login_as_user(@person) }
      When  { visit edit_person_registration_path(@person) }

      describe 'photo should be placeholded' do
        Then  { find('.form-inputs img')['src'].should have_content('/assets/fallback/person/default.png') }
      end

      describe 'should update fields without updating password' do
        When do
          attach_file 'person[photo]', "#{Rails.root}/spec/fixtures/150x200.png"
          fill_in 'person_email', with: 'test@example.com'
          fill_in 'person_spiritual_name', with: 'Adi dasa das'
          fill_in 'person_name', with: 'Vasyl'
          fill_in 'person_middle_name', with: 'Alexovich'
          fill_in 'person_surname', with: 'Mitrofanov'
          fill_in 'person_telephones_attributes_0_phone', with: '380112223344'
          select  'Male', from: 'person_gender'
          select  '1982', from: 'person_birthday_1i'
          select  'May', from: 'person_birthday_2i'
          select  '20', from: 'person_birthday_3i'
          fill_in 'person_edu_and_work', with: 'NTUU KPI'
          fill_in 'person_emergency_contact', with: 'Krishna'
          fill_in 'person_current_password', with: 'password'
          click_button 'Update'
        end

        describe 'should show flash' do
          Then { find('.alert-notice').should have_content(I18n.t('devise.registrations.updated')) }
        end

        describe 'should direct to crop path' do
          Then { find('h1').should have_content('crop image') }
        end

        describe 'should be updated' do
          When { visit edit_person_registration_path(@person) }

          Then do
            find('.form-inputs img')['src'].should have_content("/people/show_photo/standart/#{@person.id}")
            find('#person_email')['value'].should have_content('test@example.com')
            find('#person_spiritual_name')['value'].should have_content('Adi Dasa Das')
            find('#person_name')['value'].should have_content('Vasyl')
            find('#person_middle_name')['value'].should have_content('Alexovich')
            find('#person_surname')['value'].should have_content('Mitrofanov')
            find('#person_telephones_attributes_0_phone')['value'].should have_content('380112223344')
            find('#person_edu_and_work')['value'].should have_content('NTUU KPI')
            find('#person_emergency_contact')['value'].should have_content('Krishna')
            find('#person_gender').should have_css('option[selected="selected"]', text: 'Male')
            find('#person_birthday_1i').should have_css('option[selected="selected"]', text: '1982')
            find('#person_birthday_2i').should have_css('option[selected="selected"]', text: 'May')
            find('#person_birthday_3i').should have_css('option[selected="selected"]', text: '20')
          end
        end
      end

      describe 'should update password' do
        When do
          fill_in 'person_password', with: 'another_password'
          fill_in 'person_password_confirmation', with: 'another_password'
          fill_in 'person_current_password', with: 'password'
          click_button 'Update'
        end

        describe 'should show flash' do
          Then { find('.alert-notice').should have_content(I18n.t('devise.registrations.updated')) }
        end

        describe 'should allow new password' do
          When do
            logout(:person)
            visit new_person_session_path
            fill_in 'person_email', with: @person.email
            fill_in 'person_password', with: 'another_password'
            click_button I18n.t('devise.links.sign_in')
          end

          Then { find('.alert-notice').should have_content(I18n.t('devise.sessions.signed_in')) }
        end
      end
    end
  end

  describe 'forgot email' do
    Given { create :person, email: 'admin@example.com', telephones: [create(:telephone, phone: '1111111111')] }
    Given { create :person, email: 'terminator@test.org', telephones: [create(:telephone, phone: '1111111111'), create(:telephone, phone: '2222222222')] }
    Given { visit remind_email_path }

    describe 'found one email' do
      When do
        fill_in 'phone', with: '2222222222'
        click_button 'Get email'
      end

      Then { find('.found-emails').text.should match(/(\w|\*)+@test\.org/) }
      And  { find('.found-emails').text.should_not match(/(\w|\*)+@example\.com/) }
    end

    describe 'found two emails' do
      When do
        fill_in 'phone', with: '1111111111'
        click_button 'Get email'
      end

      Then { find('.found-emails').text.should match(/(\w|\*)+@example\.com.*(\w|\*)+@test\.org/) }
    end

    describe 'no email found' do
      When do
        fill_in 'phone', with: '3333333333'
        click_button 'Get email'
      end

      Then { find('.found-emails').should have_content('The telephone is not registered.') }
    end
  end
end
