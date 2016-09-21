require 'rails_helper'

describe 'Graduate academic group:' do
  Given(:group) { create :academic_group }
  Given!(:student) { create(:group_participation, academic_group: group).student_profile.person }

  context 'active student can not apply to program' do
    When { login_as(student) }
    When { init_schedules_mv }
    When { visit root_path }

    Then { expect(page).not_to have_selector('#study_application') }
  end

  context 'do the graduation' do
    When { login_as_admin }
    When { visit academic_group_path(group) }
    When { click_link I18n.t('links.graduate') }

    context 'group is graduated' do
      Then { expect(page).to have_selector('.alert-success', text: 'Academic group was successfully graduated.') }
    end

    context 'ex student can apply to program' do
      When { login_as(student) }
      When { init_schedules_mv }
      When { visit root_path }

      Then { expect(page).to have_selector('#study_application') }
    end
  end
end
