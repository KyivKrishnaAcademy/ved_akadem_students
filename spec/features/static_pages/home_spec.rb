require 'spec_helper'

describe :home do
  Given { @person = create(:person) }
  Given { login_as_user(@person) }

  When { visit '/static_pages/home' }

  context 'should have the right title' do
    Then { expect(page).to have_title("#{I18n.t :application_title} | Home") }
  end

  context 'person brief' do
    Then { find('.person-brief').should have_content(@person.name)}
  end

  context 'study applications' do
    Given { @program = create(:program, title: 'Школа Бхакти' , description: 'Описание 1') }
    Given { create(:program, title: 'Бхакти Шастры', description: 'Описание 2') }

    context 'with application' do
      Given { StudyApplication.create(person_id: @person.id, program_id: @program.id) }
      Given { @person.questionnaires << create(:questionnaire, title: 'Психо тест') }

      describe 'have elements' do
        Then  { find('#study_application').should have_content('Школа Бхакти') }
        And   { find('#study_application').should_not have_content('Бхакти Шастры') }
        And   { find('#study_application').should have_link('Withdraw') }
        And   { find('#study_application').should have_css('li', text: 'Fill questionnaire Психо тест') }
        And   { find('#study_application').should have_css('li', text: 'Attach photo here') }
        And   { find('#study_application').should have_css('li', text: 'Attach passport here') }
      end

      describe 'withdraw', :js do
        When { find('.btn-danger').click }

        Then { expect(find('#study_application')).to have_selector(:link_or_button, 'Apply') }
        And  { find('#study_application').should have_content('Школа Бхакти') }
        And  { find('#study_application').should have_content('Бхакти Шастры') }
      end
    end

    context 'without application' do
      Given (:programs) { all('#study_application .program') }

      describe 'have elements' do
        Then  { programs.first.should have_content('Школа Бхакти') }
        And   { programs.first.should have_content('Описание 1') }
        And   { programs.first.should have_selector(:link_or_button, 'Apply') }
        And   { programs.last.should have_content('Бхакти Шастры') }
        And   { programs.last.should have_content('Описание 2') }
        And   { programs.last.should have_selector(:link_or_button, 'Apply') }
      end

      describe 'apply', :js do
        When { programs.first.find('.btn-success').click }

        Then { expect(find('#study_application')).to have_link('Withdraw') }
        And  { find('#study_application').should have_content('Школа Бхакти') }
        And  { find('#study_application').should_not have_content('Бхакти Шастры') }
      end
    end
  end
end
