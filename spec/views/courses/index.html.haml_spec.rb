# require 'rails_helper'

describe 'courses/index' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:course) { create :course }
  Given(:activities) { %w[course:index] }

  Given { allow(view).to receive(:policy).with(course).and_return(CoursePolicy.new(user, course)) }

  Given { assign(:courses, [course]) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:row) { page.find('tbody tr', text: course.title) }
    Given(:table_container) { page.find('.row', text: I18n.t('courses.index.title')) }

    Given(:no_new_link) { expect(table_container).not_to have_link('', href: new_course_path) }
    Given(:no_show_link) { expect(row).not_to have_link(course.title, href: course_path(course)) }

    Given(:no_edit_link) do
      expect(table_container).not_to have_link(I18n.t('links.edit'), href: edit_course_path(course))
    end

    Given(:no_destroy_link) do
      expect(table_container).not_to have_link(I18n.t('links.delete'), href: "/courses/#{course.id}")
    end

    context 'without additional rights' do
      Then { no_show_link }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :show rights' do
      Given(:activities) { %w[course:index course:show] }

      Then { expect(row).to have_link(course.title, href: course_path(course)) }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :new rights' do
      Given(:activities) { %w[course:index course:new] }

      Then { expect(table_container).to have_link('', href: new_course_path) }
      And  { no_show_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :edit rights' do
      Given(:activities) { %w[course:index course:edit] }

      Then { expect(table_container).to have_link(I18n.t('links.edit'), href: edit_course_path(course)) }
      And  { no_show_link }
      And  { no_new_link }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:course_with_schedule) { create :course, class_schedules_count: 1 }
      Given(:course_with_examination_results) { create :course, examination_results_count: 2 }
      Given(:course_with_both) { create :course, class_schedules_count: 1, examination_results_count: 2 }

      Given(:activities) { %w[course:index course:destroy] }
      Given(:have_disabled_destroy_link) { have_selector('.disabled-button-with-popover a.btn-danger.disabled') }

      Given { allow(view).to receive(:policy).with(course_with_schedule).and_return(CoursePolicy.new(user, course_with_schedule)) }
      Given { allow(view).to receive(:policy).with(course_with_examination_results).and_return(CoursePolicy.new(user, course_with_examination_results)) }
      Given { allow(view).to receive(:policy).with(course_with_both).and_return(CoursePolicy.new(user, course_with_both)) }
      Given { assign(:courses, [course, course_with_schedule, course_with_examination_results, course_with_both]) }

      def course_row_by_title(course)
        table_container.find('tbody tr', text: course.title)
      end

      def have_course_link(course)
        have_link(I18n.t('links.delete'), href: "/courses/#{course.id}")
      end

      Then { expect(course_row_by_title(course)).to have_course_link(course) }
      And  { expect(course_row_by_title(course)).not_to have_disabled_destroy_link }
      And  { expect(course_row_by_title(course_with_schedule)).to have_disabled_destroy_link }
      And  { expect(course_row_by_title(course_with_examination_results)).to have_disabled_destroy_link }
      And  { expect(course_row_by_title(course_with_both)).to have_disabled_destroy_link }
      And  { expect(course_row_by_title(course_with_schedule)).not_to have_course_link(course_with_schedule) }
      And  { expect(course_row_by_title(course_with_examination_results)).not_to have_course_link(course_with_examination_results) }
      And  { expect(course_row_by_title(course_with_both)).not_to have_course_link(course_with_both) }
      And  { no_show_link }
      And  { no_edit_link }
      And  { no_new_link }
    end
  end
end
