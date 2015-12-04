require 'rails_helper'

describe 'Delete Certificate Template' do
  Given(:subject) { find('tbody') }
  Given(:template_1_row) { find('tbody tr', text: template_1.title) }

  Given!(:template_1) { create :certificate_template }
  Given!(:template_2) { create :certificate_template }

  Given { login_as_admin }
  Given { visit certificate_templates_path }

  describe 'there are uniq templates' do
    Then { is_expected.to have_selector('td', text: template_1.title) }
    And  { is_expected.to have_selector('td', text: template_2.title) }
    And  { expect(template_1.title).not_to eq(template_2.title) }
  end

  describe 'delete one template' do
    When { template_1_row.find('.btn-danger').click }

    Then { is_expected.not_to have_selector('td', text: template_1.title) }
    And  { is_expected.to have_selector('td', text: template_2.title) }
  end

  describe 'dismiss delete confirmation', :js do
    When { dismiss_confirm { template_1_row.find('.btn-danger').click } }
    When { visit certificate_templates_path }

    Then { is_expected.to have_selector('td', text: template_1.title) }
    And  { is_expected.to have_selector('td', text: template_2.title) }
  end
end
