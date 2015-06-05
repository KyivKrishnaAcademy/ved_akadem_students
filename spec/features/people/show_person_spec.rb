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
    Given { @academic_group_1 = create :academic_group }
    Given { @academic_group_2 = create :academic_group }
    Given { person.create_student_profile }
    Given { person.student_profile.academic_groups << @academic_group_1 }

    describe 'initial' do
      Then { expect(find('#academic-group-link')).to have_link(@academic_group_1.title) }
      And  { expect(find('#change-academic-group')).to have_css('li.disabled', visible: false, text: @academic_group_1.title) }
      And  { expect(find('#change-academic-group')).not_to have_css('li.disabled', visible: false, text: @academic_group_2.title) }
      And  { expect(find('#change-academic-group')).not_to have_css('li.disabled', visible: false, text: 'Remove from group') }
      And  { expect(find('#change-academic-group')).to have_css('li', visible: false, text: 'Remove from group') }
    end

    describe 'do change', :js do
      When { click_button 'Change group' }
      When { find('#move-to-group', text: @academic_group_2.title).click }

      Then { expect(find('#academic-group-link')).to have_link(@academic_group_2.title) }
      And  { expect(find('#change-academic-group')).to have_css('li.disabled', visible: false, text: @academic_group_2.title) }
      And  { expect(find('#change-academic-group')).not_to have_css('li.disabled', visible: false, text: @academic_group_1.title) }
      And  { expect(find('#change-academic-group')).not_to have_css('li.disabled', visible: false, text: 'Remove from group') }
      And  { expect(find('#change-academic-group')).to have_css('li', visible: false, text: 'Remove from group') }
    end

    describe 'do remove', :js do
      When { click_button 'Change group' }
      When { click_link 'Remove from group' }

      Then { expect(find('#academic-group-link')).not_to have_link(@academic_group_1.title) }
      And  { expect(find('#change-academic-group')).not_to have_css('li.disabled', visible: false, text: @academic_group_1.title) }
      And  { expect(find('#change-academic-group')).not_to have_css('li.disabled', visible: false, text: @academic_group_2.title) }
      And  { expect(find('#change-academic-group')).to have_css('li.disabled', visible: false, text: 'Remove from group') }
    end
  end
end
