require 'rails_helper'

describe 'Edit akadem group:' do
  Given(:akadem_group) { create :akadem_group }

  When do
    login_as_admin
    visit edit_akadem_group_path(akadem_group)
  end

  describe 'autocomplete admin', :js do
    Given { create :person, name: 'Synchrophazotrone' }

    When  { find('#akadem_group_administrator').set('rophazotr') }
    When  { choose_autocomplete_result('rophazotr', '#akadem_group_administrator') }
    When  { click_button 'Update Akadem group' }
    When  { find('.alert-success') }
    When  { visit edit_akadem_group_path(akadem_group) }

    Then  { expect(find('#akadem_group_administrator').value).to have_content('Synchrophazotrone') }
  end

  describe 'When values are valid:' do
    [ {field: 'Group name'       , value: 'БШ99-9'       , test_field: 'Group name: БШ99-9'        },
      {field: 'Group description', value: 'Зис из э test', test_field: 'Description: Зис из э test'} ].each do |h|
      it_behaves_like :valid_fill_in, h, 'Akadem group'
    end

    describe 'Establishment date' do
      it_behaves_like :valid_select_date, 'AkademGroup', 'establ_date', 'Establishment date: '
    end
  end

  context 'When values are invalid:' do
    it_behaves_like :invalid_fill_in, {field: 'Group name', value: '12-2'}, 'Akadem group'
  end
end
