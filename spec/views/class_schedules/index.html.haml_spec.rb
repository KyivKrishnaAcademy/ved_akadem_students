require 'rails_helper'

describe 'class_schedules/index' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:group) { create :academic_group }
  Given(:activities) { %w(class_schedule:index) }
  Given(:class_schedule) { create :class_schedule, teacher_profile: teacher_profile, academic_groups: [group] }
  Given(:teacher_profile) { create(:teacher_profile) }

  Given { allow(view).to receive(:policy).with(class_schedule)
                                         .and_return(ClassSchedulePolicy.new(user, class_schedule)) }
  Given { allow(view).to receive(:policy).with(class_schedule.course)
                                         .and_return(CoursePolicy.new(user, class_schedule.course)) }
  Given { allow(view).to receive(:policy).with(teacher_profile.person)
                                         .and_return(PersonPolicy.new(user, teacher_profile.person)) }
  Given { allow(view).to receive(:policy).with(group).and_return(AcademicGroupPolicy.new(user, group)) }

  Given { assign(:class_schedules, [class_schedule]) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:new_link_text) { 'New Class Schedule' }
    Given(:row) { page.find('tbody tr', text: class_schedule.course.title) }
    Given(:table_container) { page.find('.row', text: 'Listing Class Schedules') }

    Given(:no_new_link) { expect(table_container).not_to have_link(new_link_text, href: new_class_schedule_path) }
    Given(:no_edit_link) { expect(table_container).not_to have_link(I18n.t('links.edit'),
                                                                    href: edit_class_schedule_path(class_schedule)) }
    Given(:no_destroy_link) { expect(table_container).not_to have_link(I18n.t('links.delete'),
                                                                       href: "/class_schedules/#{class_schedule.id}") }
    Given(:no_course_link) do
      expect(row).not_to have_link(class_schedule.course.title, href: course_path(class_schedule.course))
    end

    Given(:no_person_link) do
      expect(row).not_to have_link(teacher_profile.complex_name, href: person_path(teacher_profile.person))
      expect(row).to have_content(teacher_profile.complex_name)
    end

    Given(:no_group_link) do
      expect(row).not_to have_link(group.title, href: academic_group_path(group))
      expect(row).to have_content(group.title)
    end

    context 'without additional rights' do
      Then { no_new_link }
      And  { no_edit_link }
      And  { no_destroy_link }
      And  { no_course_link }
      And  { no_person_link }
      And  { no_group_link }
    end

    context 'with :new rights' do
      Given(:activities) { %w(class_schedule:index class_schedule:new) }

      Then { expect(table_container).to have_link(new_link_text, href: new_class_schedule_path) }
      And  { no_edit_link }
      And  { no_destroy_link }
      And  { no_course_link }
      And  { no_person_link }
      And  { no_group_link }
    end

    context 'with :edit rights' do
      Given(:activities) { %w(class_schedule:index class_schedule:edit) }

      Then { expect(table_container).to have_link(I18n.t('links.edit'),
                                                  href: edit_class_schedule_path(class_schedule)) }
      And  { no_new_link }
      And  { no_destroy_link }
      And  { no_course_link }
      And  { no_person_link }
      And  { no_group_link }
    end

    context 'with :destroy rights' do
      Given(:activities) { %w(class_schedule:index class_schedule:destroy) }

      Then { expect(table_container).to have_link(I18n.t('links.delete'),
                                                  href: "/class_schedules/#{class_schedule.id}") }
      And  { no_edit_link }
      And  { no_new_link }
      And  { no_course_link }
      And  { no_person_link }
      And  { no_group_link }
    end

    context 'with course:show rights' do
      Given(:activities) { %w(class_schedule:index course:show) }

      Then { expect(row).to have_link(class_schedule.course.title, href: course_path(class_schedule.course)) }
      And  { no_edit_link }
      And  { no_destroy_link }
      And  { no_new_link }
      And  { no_person_link }
      And  { no_group_link }
    end

    context 'with person:show rights' do
      Given(:activities) { %w(class_schedule:index person:show) }

      Then { expect(row).to have_link(teacher_profile.complex_name, href: person_path(teacher_profile.person)) }
      And  { no_edit_link }
      And  { no_destroy_link }
      And  { no_course_link }
      And  { no_new_link }
      And  { no_group_link }
    end

    context 'with academic_group:show rights' do
      Given(:activities) { %w(class_schedule:index academic_group:show) }

      Then { expect(row).to have_link(group.title, href: academic_group_path(group)) }
      And  { no_edit_link }
      And  { no_destroy_link }
      And  { no_course_link }
      And  { no_person_link }
      And  { no_new_link }
    end
  end
end
