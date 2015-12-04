require 'rails_helper'

describe 'Markup Certificate Template' do
  Given(:subject) { page }
  Given(:template) { create :certificate_template }

  When { login_as_admin }
  When { visit markup_certificate_template_path(template) }

  describe 'can be submited', :js do
    When { find('input[type="submit"]').click }

    Then { is_expected.to have_selector('h1', text: I18n.t('certificate_templates.index.title')) }
  end

  describe 'has right title' do
    Then { is_expected.to have_selector('h1', text: I18n.t('certificate_templates.markup.title')) }
  end
end
