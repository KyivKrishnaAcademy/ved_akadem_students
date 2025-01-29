require 'rails_helper'

describe 'Teacher multi select for courses:', :js do
  Given(:person_1) { create :person }
  Given(:person_2) { create :person }

  Given!(:profile_1) { create :teacher_profile, person: person_1 }
  Given!(:profile_2) { create :teacher_profile, person: person_2 }

  Given(:select_container) { find('span.select2-container') }

  Given(:common_assertions) do
    select2_multi('course_teacher_profiles', person_2.complex_name)
    find('button[type="submit"]').click
    expect(page).to have_selector('.alert-dismissible.alert-success')
  end

  When { login_as_admin }

  context 'new course' do
    When { visit new_course_path }
    When { fill_in('course_title', with: 'My title') }
    When { fill_in('course_description', with: 'My description') }

    Then { expect(select_container).not_to have_selector('li.select2-selection__choice') }
    And  { common_assertions }
    And  { visit edit_course_path(Course.last) }
    And  { expect(select_container).to have_selector('li.select2-selection__choice', text: person_2.complex_name) }
  end

  context 'existing course' do
    Given(:course) { create :course, teacher_profiles: [profile_1] }

    When { visit edit_course_path(course) }

    context 'add more' do
      Then { expect(select_container).to have_selector('li.select2-selection__choice', text: person_1.complex_name, wait: 5) }
      And  { common_assertions }
      And  { visit edit_course_path(course) }
      And  { expect(select_container).to have_selector('li.select2-selection__choice', text: person_1.complex_name) }
      And  { expect(select_container).to have_selector('li.select2-selection__choice', text: person_2.complex_name) }
    end

    context 'remove some' do
      Given { course.teacher_specialities.create(teacher_profile_id: profile_2.id) }

      Then { expect(select_container).to have_selector('li.select2-selection__choice', text: person_1.complex_name, wait: 5) }
      And  { expect(select_container).to have_selector('li.select2-selection__choice', text: person_2.complex_name) }

      And do
        page.execute_script %{
          $('li.select2-selection__choice[title="#{person_1.complex_name}"]').find('span').click();
          $('select#course_teacher_profile_ids').select2('close');
        }

        true
      end

      And { expect(select_container).not_to have_selector('li.select2-selection__choice', text: person_1.complex_name) }
      And { find('button[type="submit"]').click }
      And { visit edit_course_path(course) }
      And { expect(select_container).not_to have_selector('li.select2-selection__choice', text: person_1.complex_name) }
      And { expect(select_container).to have_selector('li.select2-selection__choice', text: person_2.complex_name) }
    end
  end
end
