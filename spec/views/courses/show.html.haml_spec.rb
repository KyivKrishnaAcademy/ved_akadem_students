require 'rails_helper'

describe 'courses/show' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:course) { create :course, title: course_title }
  Given(:academic_group) { create :academic_group }
  Given(:activities) { %w[course:show] }
  Given(:course_title) { 'Bhakta Program' }
  Given(:examination_with_results) { create :examination, course: course, examination_results_count: 108 }
  Given(:examination_without_results) { create :examination, course: course }

  Given { allow(view).to receive(:policy).with(course).and_return(CoursePolicy.new(user, course)) }
  Given { allow(view).to receive(:policy).with(Course).and_return(CoursePolicy.new(user, Course)) }
  Given { allow(view).to receive(:policy).with(Examination).and_return(CoursePolicy.new(user, Examination)) }
  Given do
    allow(view).to receive(:policy).with(academic_group).and_return(AcademicGroupPolicy.new(user, academic_group))
  end

  Given { assign(:course, course) }
  Given { assign(:academic_groups, [academic_group]) }
  Given { assign(:examinations, [examination_without_results, examination_with_results]) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:container) { page.find('.row', text: course_title) }
    Given(:have_academic_group_link) { have_link(academic_group.title, href: academic_group_path(academic_group)) }
    Given(:have_edit_course_link) { have_link(I18n.t('links.edit'), href: edit_course_path(course)) }
    Given(:have_destroy_course_link) { have_link(I18n.t('links.delete'), href: "/courses/#{course.id}") }
    Given(:have_examinations_section) { have_content(I18n.t('courses.show.examinations')) }

    Given(:expect_no_edit_link) { expect(container).not_to(have_edit_course_link) }
    Given(:expect_no_destroy_link) { expect(container).not_to(have_destroy_course_link) }
    Given(:expect_no_academic_group_link) { expect(container).not_to(have_academic_group_link) }

    context 'without additional rights' do
      Then { expect_no_edit_link }
      And  { expect_no_destroy_link }
      And  { expect_no_academic_group_link }
      And  { expect(container).not_to have_examinations_section }
    end

    context 'with course:edit rights' do
      Given(:activities) { %w[course:edit] }

      Then { expect(container).to(have_edit_course_link) }
      And  { expect_no_destroy_link }
      And  { expect_no_academic_group_link }
      And  { expect(container).not_to have_examinations_section }
    end

    context 'with course:destroy rights' do
      Given(:activities) { %w[course:destroy] }

      describe 'with enabled "destroy" link' do
        Then { expect(container).to(have_destroy_course_link) }
        And  { expect_no_edit_link }
        And  { expect_no_academic_group_link }
        And  { expect(container).not_to have_examinations_section }
      end

      describe 'with disabled "destroy" link' do
        shared_examples :courses_destroy_is_disabled do
          Then { expect(container).not_to(have_destroy_course_link) }
          And  { expect(container).not_to have_examinations_section }

          And do
            expect(container).to(
              have_selector('.col-xs-12:nth-child(2) .disabled-button-with-popover a.btn-danger.disabled')
            )
          end
        end

        describe 'course has ClassSchedules' do
          Given(:course) { create :course, title: course_title, class_schedules_count: 1 }

          it_behaves_like :courses_destroy_is_disabled
        end

        describe 'course has ExaminationResults' do
          Given(:course) { create :course, title: course_title, examination_results_count: 2 }

          it_behaves_like :courses_destroy_is_disabled
        end

        describe 'course has both ClassSchedules and ExaminationResults' do
          Given(:course) { create :course, title: course_title, class_schedules_count: 1, examination_results_count: 2 }

          it_behaves_like :courses_destroy_is_disabled
        end
      end
    end

    context 'with academic_group:show rights' do
      Given(:activities) { %w[academic_group:show] }

      Then { expect(container).to(have_academic_group_link) }
      And  { expect_no_destroy_link }
      And  { expect_no_edit_link }
      And  { expect(container).not_to have_examinations_section }
    end

    context 'with examination:index rights' do
      Given(:activities) { %w[examination:index] }

      def examination_row_by_title(examination)
        page.find('tbody tr', text: examination.title)
      end

      def have_examination_link(examination)
        have_link(I18n.t('links.delete'), href: course_examination_path(examination.course_id, examination))
      end

      context 'withour additional rights' do
        Then { expect(container).to have_examinations_section }

        And do
          expect(examination_row_by_title(examination_with_results))
            .not_to(have_examination_link(examination_with_results))
        end

        And do
          expect(examination_row_by_title(examination_without_results))
            .not_to(have_examination_link(examination_without_results))
        end
      end

      context 'with examination:destroy rights' do
        Given(:activities) { %w[examination:index examination:destroy] }

        Then { expect(container).to have_examinations_section }

        And do
          expect(examination_row_by_title(examination_with_results))
            .not_to(have_examination_link(examination_with_results))
        end

        And do
          expect(examination_row_by_title(examination_with_results))
            .to(have_selector('.disabled-button-with-popover a.btn-danger.disabled'))
        end

        And do
          expect(examination_row_by_title(examination_without_results))
            .to(have_examination_link(examination_without_results))
        end
      end
    end
  end
end
