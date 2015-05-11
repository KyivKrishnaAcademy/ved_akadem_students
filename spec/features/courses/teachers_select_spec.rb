require 'rails_helper'

describe 'Teacher multi select for courses:', :js do
  Given(:person_1) { create :person }
  Given(:person_2) { create :person }

  Given!(:profile_1) { create :teacher_profile, person: person_1 }
  Given { create :teacher_profile, person: person_2 }

  Given(:select_container) { find('span.select2-container') }

  Given(:common_assertions) do
    select_container.click
    find('li.select2-results__option', text: person_2.complex_name).click
    expect(select_container).to have_selector('li.select2-selection__choice', text: person_2.complex_name)
    find('input[type="submit"]').click
    expect(page).to have_selector('.alert-dismissible.alert-notice')
  end

  When { login_as_admin }

  context 'new course' do
    When { visit new_course_path }
    When { fill_in('course_title', with: 'My title')}
    When { fill_in('course_description', with: 'My description')}

    Then { expect(select_container).not_to have_selector('li.select2-selection__choice') }
    And  { common_assertions }
  end

  context 'existing course' do
    Given(:course) { create :course, teacher_profiles: [profile_1] }

    When { visit edit_course_path(course) }

    Then { expect(select_container).to have_selector('li.select2-selection__choice', text: person_1.complex_name) }
    And  { common_assertions }
  end
end
