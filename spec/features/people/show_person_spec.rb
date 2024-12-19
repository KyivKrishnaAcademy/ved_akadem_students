require 'rails_helper'

describe 'Show person:' do
  Given(:person) { create :person }
  Given(:user) { create(:person, :admin) }

  When  { login_as(user) }
  When  { visit person_path(person) }

  describe 'study application' do
    it_behaves_like :study_applications, true
  end

  describe 'change group' do
    Given!(:academic_group_1) { create :academic_group }
    Given!(:academic_group_2) { create :academic_group }

    Given { person.create_student_profile }
    Given { person.student_profile.academic_groups << academic_group_1 }

    describe 'initial' do
      Then { expect(find('table', text: 'Група Дата вступу Дії')).to have_css('tr', text: academic_group_1.title) }

      And do
        expect(find('#change-academic-group'))
          .to have_css('li.disabled', visible: false, text: academic_group_1.title)
      end

      And do
        expect(find('#change-academic-group'))
          .not_to have_css('li.disabled', visible: false, text: academic_group_2.title)
      end
    end

    describe 'do change', :js do
      When { click_button 'Додати до групи' }
      When { find('#move-to-group', text: academic_group_2.title).click }

      Then { expect(find('table', text: 'Група Дата вступу Дії')).to have_css('tr', text: academic_group_2.title) }

      And do
        expect(find('#change-academic-group'))
          .to have_css('li.disabled', visible: false, text: academic_group_2.title)
      end

      And do
        expect(find('#change-academic-group'))
          .to have_css('li.disabled', visible: false, text: academic_group_1.title)
      end
    end
  end
end
