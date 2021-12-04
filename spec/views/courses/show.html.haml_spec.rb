require 'rails_helper'

describe 'courses/show' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:course) { create :course, title: course_title }
  Given(:activities) { %w(course:show) }
  Given(:course_title) { 'Bhakta Program' }

  Given { allow(view).to receive(:policy).with(course).and_return(CoursePolicy.new(user, course)) }
  Given { allow(view).to receive(:policy).with(Course).and_return(CoursePolicy.new(user, Course)) }
  Given { allow(view).to receive(:policy).with(Examination).and_return(CoursePolicy.new(user, Examination)) }

  Given { assign(:course, course) }
  Given { assign(:academic_groups, []) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:container) { page.find('.row', text: course_title) }

    Given(:no_edit_link) { expect(container).not_to have_link(I18n.t('links.edit'), href: edit_course_path(course)) }

    Given(:no_destroy_link) do
      expect(container).not_to have_link(I18n.t('links.delete'), href: "/courses/#{course.id}")
    end

    context 'without additional rights' do
      Then { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :edit rights' do
      Given(:activities) { %w(course:index course:edit) }

      Then { expect(container).to have_link(I18n.t('links.edit'), href: edit_course_path(course)) }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:activities) { %w(course:index course:destroy) }

      Then { expect(container).to have_link(I18n.t('links.delete'), href: "/courses/#{course.id}") }
      And  { no_edit_link }
    end
  end
end
