require 'rails_helper'

describe :home do
  Given(:person) { create(:person) }

  Given { login_as(person) }

  When  { visit '/static_pages/home' }

  context 'should have the right title' do
    Then { expect(page).to have_title("#{I18n.t :application_title} | #{I18n.t('static_pages.home.title')}") }
  end

  context 'person brief' do
    Then { expect(find('.person-brief')).to have_content(person.name)}
    And  { expect(find('.person-brief')).to have_link(I18n.t('links.edit_profile'), href: edit_person_registration_path(person)) }
  end

  describe 'schedules table' do
    Given(:group) { create :academic_group }

    Given!(:schedule_1) { create :class_schedule, academic_groups: [group] }

    Given { person.create_student_profile.academic_groups << group }
    Given { init_schedules_mv }

    Then  { expect(find('h3.text-center')).to have_content(I18n.t('static_pages.home.schedules_title')) }
  end

  describe 'study applications' do
    include_examples :study_applications, false
  end
end
