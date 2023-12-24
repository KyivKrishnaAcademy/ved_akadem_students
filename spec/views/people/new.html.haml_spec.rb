require 'rails_helper'

describe 'people/new.html.erb' do
  subject { page }

  Given { login_as_admin }

  Given(:form) { 'form.new_person' }

  When { visit new_person_path }

  describe 'have fields' do
    Then { is_expected.to have_title(full_title('Add New Person')) }
    And  { is_expected.to have_selector('h1', text: 'Add Person') }
    And  { is_expected.to have_selector(form) }
    And  { is_expected.to have_selector("#{form} input#person_name") }
    And  { is_expected.to have_selector("#{form} input#person_middle_name") }
    And  { is_expected.to have_selector("#{form} input#person_surname") }
    And  { is_expected.to have_selector("#{form} input#person_diploma_name") }
    And  { is_expected.to have_selector("#{form} input#phone") }
    And  { is_expected.to have_selector("#{form} input#person_email") }
    And  { is_expected.to have_selector("#{form} select#person_gender") }
    And  { is_expected.to have_selector("#{form} input[name='person[birthday]']") }
    And  { is_expected.to have_selector("#{form} input#person_photo") }
    And  { is_expected.to have_selector("#{form} input.btn") }
  end
end
