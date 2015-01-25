require 'rails_helper'

describe 'Edit person:' do
  subject { page }

  Given { page.set_rack_session(locale: :uk) }

  When { login_as_admin }
  When { visit edit_person_path(create(:person, birthday: '2008-10-08')) }
  #When { click_link I18n.t('links.edit') }

  context 'When values are valid:' do
    [
      { field: 'phone'                    , value: '+380 50 111 2233' , test_field: 'Telephone 1: +380 50 111 2233' },
      { field: 'person[spiritual_name]'   , value: 'AdiDasa dasa'     , test_field: 'Adidasa Dasa' },
      { field: 'person[name]'             , value: 'алексей'          , test_field: 'Алексей' },
      { field: 'person[middle_name]'      , value: 'иванович'         , test_field: 'Иванович' },
      { field: 'person[surname]'          , value: 'евгеньев'         , test_field: 'Евгеньев' },
      { field: 'person[email]'            , value: 'alex@PAMHO.net'   , test_field: 'Email: alex@pamho.net' },
      { field: 'person[education]'        , value: 'some'             , test_field: 'Education: some' },
      { field: 'person[work]'             , value: 'other'            , test_field: 'Work: other' },
      { field: 'person[special_note]'     , value: 'some note'        , test_field: 'Special note: some note' },
      { field: 'person[emergency_contact]', value: 'дядя Петя'        , test_field: 'Emergency contact: дядя Петя' }
    ].each do |h|
      it_behaves_like :valid_fill_in, h, 'Person'
    end

    describe 'Birthday' do
      When { fill_in 'person[birthday]', with: '27.05.1985' }
      When { click_button 'Update Person' }

      describe 'brithdate is shown' do
        Then { expect(find('body')).to have_content('Birthday: 1985-05-27') }
      end

      it_behaves_like :alert_success_updated, 'Person'
    end

    describe 'Gender' do
      it_behaves_like :valid_select, 'Person', 'person[gender]', 'Чоловіча' ,'Gender: Male'
      it_behaves_like :valid_select, 'Person', 'person[gender]', 'Жіноча'   ,'Gender: Female'
    end
  end

  context 'When values are invalid:' do
    [
      { field: 'person[telephones_attributes][0][phone]', value: '050 111 2233' },
      { field: 'person[email]'  , value: '@@.com@' },
      { field: 'person[name]'   , value: '' },
      { field: 'person[surname]', value: '' }
    ].each do |h|
      describe h[:field] do
        When do
          fill_in(h[:field], with: h[:value])
          click_button('Update Person')
        end

        Then { expect(find('body')).to have_selector('.alert-danger') }
        And  { expect(find('.has-error')).to have_selector('span.help-block') }
      end
    end
  end
end
