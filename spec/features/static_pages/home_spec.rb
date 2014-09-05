require 'spec_helper'

describe :home do
  Given { @person = create(:person) }
  Given { login_as_user(@person) }

  When { visit '/static_pages/home' }

  context 'should have the right title' do
    Then { expect(page).to have_title("#{I18n.t :application_title} | Home") }
  end

  context 'person brief' do
    Then { find('.person_brief').should have_content(@person.name)}
  end

  context 'study applications' do
    context 'without application' do
      Given { StudyApplication.create(person_id: @person.id, program_id: create(:program, title: 'Школа Бхакти').id) }

      Then  { find('#study_application').should have_content('Школа Бхакти') }
      And   { find('#study_application').should have_link('Withdraw') }
    end

    context 'without application' do
      Given { create(:program, title: 'Школа Бхакти' , description: 'Описание 1') }
      Given { create(:program, title: 'Бхакти Шастры', description: 'Описание 2') }
      Given (:programs) { all('#study_application .program') }

      Then  { programs.first.should have_content('Школа Бхакти') }
      And   { programs.first.should have_content('Описание 1') }
      And   { programs.first.should have_selector(:link_or_button, 'Apply') }
      And   { programs.last.should have_content('Бхакти Шастры') }
      And   { programs.last.should have_content('Описание 2') }
      And   { programs.last.should have_selector(:link_or_button, 'Apply') }
    end
  end
end
