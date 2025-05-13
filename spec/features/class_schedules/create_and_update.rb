# require 'rails_helper'

describe 'ClassSchedule create and update:', :js do
  Given(:person) { create :person }

  Given!(:course) { create :course }
  Given!(:group_1) { create :academic_group }
  Given!(:group_2) { create :academic_group }
  Given!(:classroom) { create :classroom }
  Given!(:teacher_profile) { create :teacher_profile, person: person }

  Given(:course_select) { find('.class_schedule_course span.select2-container') }
  Given(:groups_select) { find('.class_schedule_academic_groups span.select2-container') }
  Given(:teacher_select) { find('.class_schedule_teacher_profile span.select2-container') }
  Given(:classroom_select) { find('.class_schedule_classroom span.select2-container') }

  When { login_as_admin }

  describe 'create' do
    When { visit new_class_schedule_path }

    describe 'form is empty' do
      Then { expect(course_select).not_to have_selector(".select2-selection__rendered[title='#{course.title}']") }

      And do
        expect(teacher_select).not_to have_selector(".select2-selection__rendered[title='#{person.complex_name}']")
      end

      And { expect(classroom_select).not_to have_selector(".select2-selection__rendered[title='#{classroom.title}']") }
      And { expect(groups_select).not_to have_selector('li.select2-selection__choice', text: group_1.title) }
      And { expect(groups_select).not_to have_selector('li.select2-selection__choice', text: group_2.title) }
      And { expect(find('#class_schedule_subject').value).to be_empty }
    end

    describe 'valid fill' do
      When { select2_single('class_schedule_course', course.title) }
      When { select2_single('class_schedule_classroom', classroom.title) }
      When { select2_single('class_schedule_teacher_profile', person.complex_name) }
      When { select2_multi('class_schedule_academic_groups', group_1.title) }
      When { select2_multi('class_schedule_academic_groups', group_2.title) }
      When { fill_in 'class_schedule_start_time', with: '02.01.2019, 12:00' }
      When { fill_in 'class_schedule_finish_time', with: '02.01.2019, 13:00' }
      When { fill_in 'class_schedule_subject', with: 'My special subject' }

      describe 'single create' do
        When { first('input[type="submit"]').click }

        subject { find('table tbody') }

        Then { expect(page).to have_selector('.alert-dismissible.alert-success') }
        And  { is_expected.to have_selector('tbody tr', count: 1) }
        And  { is_expected.to have_selector('td', text: course.title) }
        And  { is_expected.to have_selector('td', text: classroom.title) }
        And  { is_expected.to have_selector('td', text: complex_name(person, short: true)) }
        And  { is_expected.to have_selector('td', text: group_1.title) }
        And  { is_expected.to have_selector('td', text: group_2.title) }
        And  { is_expected.to have_selector('td', text: 'Ср 02.01.19 12:00 - 13:00') }
        And  { is_expected.to have_selector('td', text: 'My special subject') }
      end

      describe 'create and clone' do
        When { find("input[value='#{I18n.t('class_schedules.create_and_clone')}']").click }

        Then { expect(page).to have_selector('.alert-dismissible.alert-success') }
        And  { expect(course_select).to have_selector(".select2-selection__rendered[title='#{course.title}']") }
        And  { expect(teacher_select).to have_selector(".select2-selection__rendered[title='#{person.complex_name}']") }
        And  { expect(classroom_select).to have_selector(".select2-selection__rendered[title='#{classroom.title}']") }
        And  { expect(groups_select).to have_selector('li.select2-selection__choice', text: group_1.title) }
        And  { expect(groups_select).to have_selector('li.select2-selection__choice', text: group_2.title) }
        And  { expect(find('input#class_schedule_start_time').value).to eq('2019-01-09T12:00') }
        And  { expect(find('input#class_schedule_finish_time').value).to eq('2019-01-09T13:00') }
        And  { expect(find('#class_schedule_subject').value).to eq('My special subject') }
      end
    end
  end

  describe 'update' do
    Given(:class_schedule) do
      create(
        :class_schedule,
        course: course,
        teacher_profile: teacher_profile,
        classroom: classroom,
        academic_groups: [group_1, group_2],
        start_time: '02.01.2019 12:00',
        finish_time: '02.01.2019 13:00'
      )
    end

    When { visit edit_class_schedule_path(class_schedule) }

    describe 'check filled right' do
      Then { expect(course_select).to have_selector(".select2-selection__rendered[title='#{course.title}']") }
      And  { expect(teacher_select).to have_selector(".select2-selection__rendered[title='#{person.complex_name}']") }
      And  { expect(classroom_select).to have_selector(".select2-selection__rendered[title='#{classroom.title}']") }
      And  { expect(groups_select).to have_selector('li.select2-selection__choice', text: group_1.title) }
      And  { expect(groups_select).to have_selector('li.select2-selection__choice', text: group_2.title) }
      And  { expect(find('input#class_schedule_start_time').value).to eq('2019-01-02T12:00') }
      And  { expect(find('input#class_schedule_finish_time').value).to eq('2019-01-02T13:00') }
    end

    describe 'change' do
      Given(:person_2) { create :person }

      Given!(:course_2) { create :course }
      Given!(:group_3) { create :academic_group }
      Given!(:classroom_2) { create :classroom }
      Given!(:teacher_profile_2) { create :teacher_profile, person: person_2 }

      When { select2_single('class_schedule_course', course_2.title) }
      When { select2_single('class_schedule_classroom', classroom_2.title) }
      When { select2_single('class_schedule_teacher_profile', person_2.complex_name) }
      When { select2_multi('class_schedule_academic_groups', group_3.title) }
      When { fill_in 'class_schedule_start_time', with: '02.01.2019, 14:00' }
      When { fill_in 'class_schedule_finish_time', with: '02.01.2019, 15:00' }
      When { select2_remove_multi('class_schedule_academic_group_ids', group_1.title) }

      When { find('input[type="submit"]').click }

      subject { find('table tbody') }

      Then { expect(page).to have_selector('.alert-dismissible.alert-success') }
      And  { is_expected.to have_selector('tr', count: 1) }
      And  { is_expected.to have_selector('td', text: course_2.title) }
      And  { is_expected.to have_selector('td', text: classroom_2.title) }
      And  { is_expected.to have_selector('td', text: complex_name(person_2, short: true)) }
      And  { is_expected.not_to have_selector('td', text: group_1.title) }
      And  { is_expected.to have_selector('td', text: group_2.title) }
      And  { is_expected.to have_selector('td', text: group_3.title) }
      And  { is_expected.to have_selector('td', text: 'Ср 02.01.19 14:00 - 15:00') }
    end
  end
end
