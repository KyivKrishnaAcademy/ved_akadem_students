require 'rails_helper'

describe 'Create Certificate Template' do
  Given(:subject) { page }

  Given { create(:institution)}
  Given { login_as_admin }
  Given { visit new_certificate_template_path }

  describe 'can not create' do
    When { find('button[type="submit"]').click }

    Then { is_expected.to have_selector('form .alert-danger') }
    And  { is_expected.to have_selector('h1.text-center', text: I18n.t('certificate_templates.new.title')) }
  end

  describe 'can create' do
    When { fill_in 'certificate_template[title]', with: 'some certificate title' }
    When { find('button[type="submit"]').click }

    Then { is_expected.to have_selector('.alert-success') }
  end
end
