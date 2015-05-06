require 'rails_helper'

describe 'courses/index' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:course) { create :course }
  Given(:activities) { %w(course:index) }

  Given { allow(view).to receive(:policy).with(course).and_return(CoursePolicy.new(user, course)) }

  Given { assign(:courses, [course]) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:row) { page.find('tbody tr', text: course.name) }
    Given(:table_container) { page.find('.row', text: 'Listing courses') }

    Given(:no_new_link) { expect(table_container).not_to have_link('New Course', href: new_course_path) }
    Given(:no_show_link) { expect(row).not_to have_link(course.name, href: course_path(course)) }
    Given(:no_edit_link) { expect(table_container).not_to have_link(I18n.t('links.edit'), href: edit_course_path(course)) }
    Given(:no_destroy_link) { expect(table_container).not_to have_link(I18n.t('links.delete'), href: "/courses/#{course.id}") }

    context 'without additional rights' do
      Then { no_show_link }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :show rights' do
      Given(:activities) { %w(course:index course:show) }

      Then { expect(row).to have_link(course.name, href: course_path(course)) }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :new rights' do
      Given(:activities) { %w(course:index course:new) }

      Then { expect(table_container).to have_link('New Course', href: new_course_path) }
      And  { no_show_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :edit rights' do
      Given(:activities) { %w(course:index course:edit) }

      Then { expect(table_container).to have_link(I18n.t('links.edit'), href: edit_course_path(course)) }
      And  { no_show_link }
      And  { no_new_link }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:activities) { %w(course:index course:destroy) }

      Then { expect(table_container).to have_link(I18n.t('links.delete'), href: "/courses/#{course.id}") }
      And  { no_show_link }
      And  { no_edit_link }
      And  { no_new_link }
    end
  end
end
