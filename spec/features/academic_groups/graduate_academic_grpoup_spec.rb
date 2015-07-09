require 'rails_helper'

describe 'Graduate academic group:' do
  Given(:group) { create :academic_group }

  When { login_as_admin }
  When { visit academic_group_path(group) }
  When { click_link I18n.t('links.graduate') }

  Then { expect(page).to have_selector('.alert-success', text: 'Academic group was successfully graduated.') }
end
