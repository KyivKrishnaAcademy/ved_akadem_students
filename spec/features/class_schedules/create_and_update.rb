require 'rails_helper'

describe 'ClassSchedule create and update:', :js do
  Given(:person) { create :person }

  Given!(:course) { create :course }
  Given!(:group_1) { create :academic_group }
  Given!(:group_2) { create :academic_group }
  Given!(:classroom) { create :classroom }
  Given!(:teacher_profile) { create :teacher_profile, person: person }

  When { login_as_admin }

  describe 'create' do
    When { visit new_class_schedule_path }

    describe 'form is empty' do
      Given(:course_select) { find('.class_schedule_course span.select2-container') }
      Given(:groups_select) { find('.class_schedule_academic_groups span.select2-container') }
      Given(:teacher_select) { find('.class_schedule_teacher_profile span.select2-container') }
      Given(:classroom_select) { find('.class_schedule_classroom span.select2-container') }

      Then { expect(course_select).not_to have_selector(".select2-selection__rendered[title='#{course.title}']") }
      And  { expect(teacher_select).not_to have_selector(".select2-selection__rendered[title='#{person.complex_name}']") }
      And  { expect(classroom_select).not_to have_selector(".select2-selection__rendered[title='#{classroom.title}']") }
      And  { expect(groups_select).not_to have_selector('li.select2-selection__choice', text: group_1.title) }
      And  { expect(groups_select).not_to have_selector('li.select2-selection__choice', text: group_2.title) }
    end

    describe 'valid fill' do
      When { select2_single('class_schedule_course', course.title) }
      When { select2_single('class_schedule_classroom', classroom.title) }
      When { select2_single('class_schedule_teacher_profile', person.complex_name) }
      When { select2_multi('class_schedule_academic_groups', group_1.title ) }
      When { select2_multi('class_schedule_academic_groups', group_2.title ) }
      When { page.execute_script %Q{
               $('.class_schedule_start_time #date-time-picker').data('DateTimePicker').date('01.01.2015 12:00')
             } }
      When { page.execute_script %Q{
               $('.class_schedule_finish_time #date-time-picker').data('DateTimePicker').date('01.01.2015 13:00')
             } }
      When { find('input[type="submit"]').click }

      subject { find('table tbody') }

      Then { expect(page).to have_selector('.alert-dismissible.alert-notice') }
      And  { is_expected.to have_selector('tr', count: 1) }
      And  { is_expected.to have_selector('td', text: course.title) }
      And  { is_expected.to have_selector('td', text: classroom.title) }
      And  { is_expected.to have_selector('td', text: person.complex_name) }
      And  { is_expected.to have_selector('td', text: group_1.title) }
      And  { is_expected.to have_selector('td', text: group_2.title) }
      And  { is_expected.to have_selector('td', text: 'Чт 01.01.15 12:00') }
      And  { is_expected.to have_selector('td', text: 'Чт 01.01.15 13:00') }
    end
  end
end
