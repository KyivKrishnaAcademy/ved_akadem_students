# require 'rails_helper'

describe 'Show ClassSchedule on AcademicGroup page', :js do
  Given(:group) { create :academic_group }

  When { login_as_admin }
  When { visit academic_group_path(group) }
  When { find('a[href="#schedules"]').click }

  subject { page.find('#schedules') }

  context 'no schedule' do
    Then { is_expected.to have_content(I18n.t('academic_groups.show.no_pending_schedules')) }
    And  { is_expected.to have_content(I18n.t('class_schedules.table_headers.time')) }
  end

  context 'some schedules' do
    Given { create :class_schedule, academic_groups: [group] }

    Then  { is_expected.to have_content(I18n.t('class_schedules.table_headers.time')) }
    And   { is_expected.not_to have_content(I18n.t('academic_groups.show.no_pending_schedules')) }
  end
end
