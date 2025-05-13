# require 'rails_helper'

describe 'Delete program:', :js do
  Given!(:program) { create(:program) }
  Given(:user) { create(:person)}
  Given(:activities) { %w[program:index] }
  Given(:delete_program_link_selector) { "a.btn-danger" }

  Given { user.roles << create(:role, activities: activities) }
  Given { login_as(user) }

  When { visit programs_path }

  describe 'without rights' do
    Then { expect(page).not_to have_selector(delete_program_link_selector) }
  end

  describe 'with rights but with study application' do
    Given(:activities) { %w[program:index program:destroy] }
    Given(:student) { create(:person, :student) }

    Given { StudyApplication.create(person_id: student.id, program_id: program.id) }

    Then { expect(find('tbody tr:nth-child(1) td:nth-child(3)')).to have_content('1') }
    And  { expect(find('tbody tr:nth-child(1) td:nth-child(7)')).to have_selector('a.btn-danger.disabled') }
  end

  describe 'with rights to destroy' do
    Given(:activities) { %w[program:index program:destroy] }
    Given(:program_title) { program["title_#{user.locale}"] }

    describe 'dismiss_confirm' do
      When { dismiss_confirm { find(delete_program_link_selector).click } }

      Then { expect(find('tbody tr:nth-child(1) td:nth-child(1)')).to have_content(program_title) }
    end

    describe 'accept_confirm' do
      When { accept_confirm { find(delete_program_link_selector).click } }

      Then { expect(page).not_to have_selector('tbody tr') }
      And  { expect(current_path).to eq(programs_path) }
    end
  end
end
