require 'rails_helper'

describe 'Edit academic group:' do
  Given(:academic_group) { create :academic_group }

  When { login_as_admin }
  When { visit edit_academic_group_path(academic_group) }

  %w(administrator praepostor curator).each do |admin_type|
    describe "autocomplete #{admin_type}", :pending, :js do
      Given { create :person, name: 'Synchrophazotrone' }

      When  { find("#academic_group_#{admin_type}").set('rophazotr') }
      When  { choose_autocomplete_result('rophazotr', "#academic_group_#{admin_type}") }
      When  { click_button 'Зберегти Academic group' }
      When  { find('.alert-success') }
      When  { visit edit_academic_group_path(academic_group) }

      Then  { expect(find("#academic_group_#{admin_type}").value).to have_content('Synchrophazotrone') }
    end
  end

  describe 'When values are valid:' do
    [{ field: 'Group name', value: 'БШ99-9', test_field: 'БШ99-9'},
     { field: I18n.t('activerecord.attributes.academic_group.group_description'),
       value: 'Зис из э test',
       test_field: "#{I18n.t('activerecord.attributes.academic_group.group_description')}: Зис из э test" }].each do |h|
         it_behaves_like :valid_fill_in, h, 'Academic group'
       end

    describe 'Establishment date' do
      it_behaves_like :valid_select_date, 'AcademicGroup', 'establ_date', "#{I18n.t('activerecord.attributes.academic_group.establ_date')}: "
    end
  end

  context 'When values are invalid:' do
    it_behaves_like :invalid_fill_in, {field: 'Group name', value: '12-2'}, 'Academic group'
  end
end
