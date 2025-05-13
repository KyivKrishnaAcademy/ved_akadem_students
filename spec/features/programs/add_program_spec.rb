# require 'rails_helper'

describe 'Add program:', :js do
  Given(:user) { create(:person)}
  Given(:activities) { %w[program:index] }
  Given(:new_program_link_selector) { "a.btn-success[href=\"#{new_program_path}\"]" }

  Given { user.roles << create(:role, activities: activities) }
  Given { login_as(user) }

  When { visit programs_path }

  describe 'without rights' do
    describe 'link navigation' do
      Then { expect(page).not_to have_selector(new_program_link_selector) }
    end

    describe 'direct navigation' do
      When { visit new_program_path }

      Then { expect(find('.alert-dismissible')).to have_content(I18n.t('not_authorized')) }
      And  { expect(current_path).not_to eq(new_program_path) }
    end
  end

  describe 'with rights to view form' do
    Given(:activities) { %w[program:index program:new] }

    describe 'navigates to the page directly' do
      When { visit new_program_path }

      Then { expect(current_path).to eq(new_program_path) }
    end

    describe 'does not allow to create' do
      When { find(new_program_link_selector).click }
      When { click_button I18n.t('programs.new.submit') }

      Then { expect(find('.alert-dismissible')).to have_content(I18n.t('not_authorized')) }
      And  { expect(current_path).to eq(new_program_path) }
    end
  end

  describe 'with rights to create' do
    Given(:activities) { %w[program:index program:new program:create] }

    describe 'creates the program' do
      When { find(new_program_link_selector).click }
      When { fill_program_data manager: user }
      When { click_button I18n.t('programs.new.submit') }

      Then { expect(current_path).to eq(programs_path) }
      And  { expect(page).to have_selector('.alert-success') }
    end
  end

  def fill_program_data(params = {})
    program = build_stubbed(:program, params)

    fill_in 'program_title_uk', with: program.title_uk
    fill_in 'program_title_ru', with: program.title_ru
    fill_in 'program_description_uk', with: program.description_uk
    fill_in 'program_description_ru', with: program.description_ru

    visibility_label = I18n.t("simple_form.options.program.visible.#{program.visible ? 'visible' : 'invisible' }")

    select visibility_label, from: 'program_visible'

    select2_single('program_manager', program.manager.complex_name)

    program
  end
end
