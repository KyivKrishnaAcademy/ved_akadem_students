require 'rails_helper'

describe :home do
  Given { @person = create(:person) }
  Given { login_as_user(@person) }

  When { visit '/static_pages/home' }

  context 'should have the right title' do
    Then { expect(page).to have_title("#{I18n.t :application_title} | #{I18n.t('static_pages.title.home')}") }
  end

  context 'person brief' do
    Then { expect(find('.person-brief')).to have_content(@person.name)}
    And  { expect(find('.person-brief')).to have_link(I18n.t('links.edit_profile'), href: edit_person_registration_path(@person)) }
  end

  context 'study applications' do
    Given { @program = create(:program, title_uk: 'Школа Бхакти' , description_uk: 'Описание 1') }
    Given { create(:program, title_uk: 'Бхакти Шастры', description_uk: 'Описание 2') }

    context 'with application' do
      Given { StudyApplication.create(person_id: @person.id, program_id: @program.id) }
      Given { @person.questionnaires << create(:questionnaire, title_uk: 'Психо тест') }

      describe 'have elements' do
        Then  { expect(find('#study_application')).to have_content('Школа Бхакти') }
        And   { expect(find('#study_application')).not_to have_content('Бхакти Шастры') }
        And   { expect(find('#study_application')).to have_link(I18n.t('links.withdraw')) }
        And   { expect(find('#study_application')).to have_css('li', text: 'Заповнити Психо тест') }
        And   { expect(find('#study_application')).to have_css('li', text: 'Додати фотографію до профайлу') }
        And   { expect(find('#study_application')).to have_css('li', text: 'Додати паспорт до профайлу') }
      end

      describe 'withdraw', :js do
        When { find('.btn-danger').click }

        Then { expect(find('#study_application')).to have_selector(:link_or_button, I18n.t('links.apply_to_program')) }
        And  { expect(find('#study_application')).to have_content('Школа Бхакти') }
        And  { expect(find('#study_application')).to have_content('Бхакти Шастры') }
      end
    end

    context 'without application' do
      Given (:programs) { all('#study_application .panel-info') }

      describe 'have elements' do
        Then  { expect(programs.first).to have_content('Школа Бхакти') }
        And   { expect(programs.first).to have_content('Описание 1') }
        And   { expect(programs.first).to have_selector(:link_or_button, I18n.t('links.apply_to_program')) }
        And   { expect(programs.last).to have_content('Бхакти Шастры') }
        And   { expect(programs.last).to have_content('Описание 2') }
        And   { expect(programs.last).to have_selector(:link_or_button, I18n.t('links.apply_to_program')) }
      end

      describe 'apply', :js do
        When { programs.first.find('.btn-success').click }

        Then { expect(find('#study_application')).to have_link(I18n.t('links.withdraw')) }
        And  { expect(find('#study_application')).to have_content('Школа Бхакти') }
        And  { expect(find('#study_application')).not_to have_content('Бхакти Шастры') }
      end
    end
  end
end
