require 'rails_helper'

describe 'courses/show' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:course) { create :course, title: course_title }
  Given(:academic_group) { create :academic_group }
  Given(:activities) { %w(course:show) }
  Given(:course_title) { 'Bhakta Program' }

  Given { allow(view).to receive(:policy).with(course).and_return(CoursePolicy.new(user, course)) }
  Given { allow(view).to receive(:policy).with(Course).and_return(CoursePolicy.new(user, Course)) }
  Given { allow(view).to receive(:policy).with(Examination).and_return(CoursePolicy.new(user, Examination)) }
  Given { allow(view).to receive(:policy).with(academic_group).and_return(AcademicGroupPolicy.new(user, academic_group)) }

  Given { assign(:course, course) }
  Given { assign(:academic_groups, [academic_group]) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:container) { page.find('.row', text: course_title) }
    Given(:have_academic_group_link) { have_link(academic_group.title, href: academic_group_path(academic_group)) }
    Given(:have_edit_course_link) { have_link(I18n.t('links.edit'), href: edit_course_path(course)) }
    Given(:have_destroy_course_link) { have_link(I18n.t('links.delete'), href: "/courses/#{course.id}") }

    Given(:expect_no_edit_link) { expect(container).not_to(have_edit_course_link) }
    Given(:expect_no_destroy_link) { expect(container).not_to(have_destroy_course_link) }
    Given(:expect_no_academic_group_link) { expect(container).not_to(have_academic_group_link) }

    context 'without additional rights' do
      Then { expect_no_edit_link }
      And  { expect_no_destroy_link }
      And  { expect_no_academic_group_link }
    end

    context 'with course:edit rights' do
      Given(:activities) { %w(course:edit) }

      Then { expect(container).to(have_edit_course_link) }
      And  { expect_no_destroy_link }
      And  { expect_no_academic_group_link }
    end

    context 'with course:destroy rights' do
      Given(:activities) { %w(course:destroy) }

      Then { expect(container).to(have_destroy_course_link) }
      And  { expect_no_edit_link }
      And  { expect_no_academic_group_link }
    end

    context 'with academic_group:show rights' do
      Given(:activities) { %w(academic_group:show) }

      Then { expect(container).to(have_academic_group_link) }
      And  { expect_no_destroy_link }
      And  { expect_no_edit_link }
    end
  end
end
