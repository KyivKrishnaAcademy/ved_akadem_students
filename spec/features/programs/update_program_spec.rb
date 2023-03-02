require 'rails_helper'

describe 'Update program:', :js do
  Given!(:program) { create(:program) }
  Given(:user) { create(:person)}
  Given(:activities) { %w[program:index] }
  Given(:edit_path) { edit_program_path(program.id) }
  Given(:edit_program_link_selector) { "a.btn-warning[href=\"#{edit_path}\"]" }

  Given { user.roles << create(:role, activities: activities) }
  Given { login_as(user) }

  When { visit programs_path }

  describe 'without rights' do
    describe 'link navigation' do
      Then { expect(page).not_to have_selector(edit_program_link_selector) }
    end

    describe 'direct navigation' do
      When { visit edit_path }

      Then { expect(find('.alert-dismissible')).to have_content(I18n.t('not_authorized')) }
      And  { expect(current_path).not_to eq(edit_path) }
    end
  end

  describe 'with rights to view form' do
    Given(:activities) { %w[program:index program:edit] }

    describe 'navigates to the page directly' do
      When { visit edit_path }

      Then { expect(current_path).to eq(edit_path) }
    end

    describe 'does not allow to save' do
      When { find(edit_program_link_selector).click }
      When { click_button I18n.t('programs.edit.submit') }

      Then { expect(find('.alert-dismissible')).to have_content(I18n.t('not_authorized')) }
      And  { expect(current_path).to eq(edit_path) }
    end
  end

  describe 'with rights to create' do
    Given(:activities) { %w[program:index program:edit program:update] }
    Given(:title_id) { "program_title_#{user.locale}"}
    Given(:new_title_value) { 'Some title here' }

    describe 'check the state of unmodified fields' do
      Then { expect(find('tbody tr:nth-child(1) td:nth-child(1)')).not_to have_content(new_title_value) }
      And  { expect(find('tbody tr:nth-child(1) td:nth-child(6)')).to have_content('0') }
      And  { expect(current_path).to eq(programs_path) }
    end

    describe 'updates the program' do
      Given(:questionnaire_title_field) { "title_#{user.locale}" }
      Given!(:questionnaire_1) { create(:questionnaire) }
      Given!(:questionnaire_2) { create(:questionnaire) }

      When { find(edit_program_link_selector).click }
      When { fill_in title_id, with: new_title_value }
      When { select2_multi('program_questionnaires', questionnaire_1[questionnaire_title_field]) }
      When { select2_multi('program_questionnaires', questionnaire_2[questionnaire_title_field]) }
      When { click_button I18n.t('programs.edit.submit') }

      Then { expect(current_path).to eq(programs_path) }
      And  { expect(page).to have_selector('.alert-notice') }
      Then { expect(find('tbody tr:nth-child(1) td:nth-child(1)')).to have_content(new_title_value) }
      And  { expect(find('tbody tr:nth-child(1) td:nth-child(6)')).to have_content('2') }
    end
  end
end
