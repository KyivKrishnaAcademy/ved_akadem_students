require 'rails_helper'

describe 'Edit akadem group:' do
  Given(:akadem_group) { create :akadem_group }

  When { login_as_admin }
  When { visit edit_akadem_group_path(akadem_group) }

  %w[administrator praepostor curator].each do |admin_type|
    describe "autocomplete #{admin_type}", :js do
      Given { create :person, name: 'Synchrophazotrone' }

      When  { find("#akadem_group_#{admin_type}").set('rophazotr') }
      When  { choose_autocomplete_result('rophazotr', "#akadem_group_#{admin_type}") }
      When  { click_button 'Зберегти Akadem group' }
      When  { find('.alert-success') }
      When  { visit edit_akadem_group_path(akadem_group) }

      Then  { expect(find("#akadem_group_#{admin_type}").value).to have_content('Synchrophazotrone') }
    end
  end

  describe 'When values are valid:' do
    [{ field: 'Group name', value: 'БШ99-9', test_field: 'БШ99-9'},
     { field: I18n.t('activerecord.attributes.akadem_group.group_description'),
       value: 'Зис из э test',
       test_field: "#{I18n.t('activerecord.attributes.akadem_group.group_description')}: Зис из э test" }].each do |h|
         it_behaves_like :valid_fill_in, h, 'Akadem group'
       end

    describe 'Establishment date' do
      it_behaves_like :valid_select_date, 'AkademGroup', 'establ_date', "#{I18n.t('activerecord.attributes.akadem_group.establ_date')}: "
    end
  end

  context 'When values are invalid:' do
    it_behaves_like :invalid_fill_in, {field: 'Group name', value: '12-2'}, 'Akadem group'
  end
end
