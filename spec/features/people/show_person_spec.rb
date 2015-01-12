require 'rails_helper'

describe 'Show person:' do
  Given { page.set_rack_session(locale: :uk) }

  Given(:person) { create :person }

  When  { login_as_admin }
  When  { visit person_path(person) }

  describe 'study application' do
    it_behaves_like :study_applications, true
  end

  describe 'change group' do
    Given { @akadem_group_1 = create :akadem_group }
    Given { @akadem_group_2 = create :akadem_group }
    Given { person.create_student_profile }
    Given { person.student_profile.akadem_groups << @akadem_group_1 }

    describe 'initial' do
      Then { expect(find('#akadem-group-link')).to have_link(@akadem_group_1.group_name) }
      And  { expect(find('#change-akadem-group')).to have_css('li.disabled', visible: false, text: @akadem_group_1.group_name) }
      And  { expect(find('#change-akadem-group')).not_to have_css('li.disabled', visible: false, text: @akadem_group_2.group_name) }
      And  { expect(find('#change-akadem-group')).not_to have_css('li.disabled', visible: false, text: 'Remove from group') }
      And  { expect(find('#change-akadem-group')).to have_css('li', visible: false, text: 'Remove from group') }
    end

    describe 'do change', :js do
      When { click_button 'Change group' }
      When { find('#move-to-group', text: @akadem_group_2.group_name).click }

      Then { expect(find('#akadem-group-link')).to have_link(@akadem_group_2.group_name) }
      And  { expect(find('#change-akadem-group')).to have_css('li.disabled', visible: false, text: @akadem_group_2.group_name) }
      And  { expect(find('#change-akadem-group')).not_to have_css('li.disabled', visible: false, text: @akadem_group_1.group_name) }
      And  { expect(find('#change-akadem-group')).not_to have_css('li.disabled', visible: false, text: 'Remove from group') }
      And  { expect(find('#change-akadem-group')).to have_css('li', visible: false, text: 'Remove from group') }
    end

    describe 'do remove', :js do
      When { click_button 'Change group' }
      When { click_link 'Remove from group' }

      Then { expect(find('#akadem-group-link')).not_to have_link(@akadem_group_1.group_name) }
      And  { expect(find('#change-akadem-group')).not_to have_css('li.disabled', visible: false, text: @akadem_group_1.group_name) }
      And  { expect(find('#change-akadem-group')).not_to have_css('li.disabled', visible: false, text: @akadem_group_2.group_name) }
      And  { expect(find('#change-akadem-group')).to have_css('li.disabled', visible: false, text: 'Remove from group') }
    end
  end
end
