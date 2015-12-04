require 'rails_helper'

describe 'Edit Certificate Template' do
  Given(:subject) { page }
  Given(:template) { create :certificate_template }

  Given { login_as_admin }
  Given { visit edit_certificate_template_path(template) }

  describe 'can not edit' do
    When { fill_in 'certificate_template[title]', with: '' }
    When { find('button[type="submit"]').click }

    Then { is_expected.to have_selector('form .alert-danger') }
    And  { is_expected.to have_selector('h1.text-center', text: I18n.t('certificate_templates.edit.title')) }
  end

  describe 'can edit' do
    Given(:new_title) { 'some certificate title' }

    When { fill_in 'certificate_template[title]', with: new_title }
    When { find('button[type="submit"]').click }

    Then { is_expected.to have_selector('.alert-notice') }
    And  { is_expected.to have_selector('h1', text: I18n.t('certificate_templates.edit.title')) }
    And  { expect(find('#certificate_template_title').value).to eq(new_title) }
  end
end
