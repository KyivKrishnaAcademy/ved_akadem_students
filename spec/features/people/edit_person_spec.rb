require 'rails_helper'

describe 'Edit person:' do
  subject { page }

  When { login_as_admin }
  When { visit edit_person_path(create(:person, birthday: '2008-10-08')) }

  context 'When values are valid:' do
    [
      { field: 'phone',                     value: '+380 50 111 2233',  test_field: 'Telephone 1: +380501112233' },
      { field: 'phone',                     value: '50 111 2233',       test_field: 'Telephone 1: +380501112233' },
      { field: 'phone',                     value: '+7 495 739-22-22',  test_field: 'Telephone 1: +74957392222' },
      { field: 'person[name]',              value: 'Алексей',           test_field: 'Алексей' },
      { field: 'person[work]',              value: 'other',             test_field: 'Work: other' },
      { field: 'person[email]',             value: 'alex@PAMHO.net',    test_field: 'Email: alex@pamho.net' },
      { field: 'person[surname]',           value: 'Евгеньев',          test_field: 'Евгеньев' },
      { field: 'person[education]',         value: 'some',              test_field: 'Education: some' },
      { field: 'person[middle_name]',       value: 'Иванович',          test_field: 'Иванович' },
      { field: 'person[emergency_contact]', value: 'дядя Петя',         test_field: 'Emergency contact: дядя Петя' }
    ].each do |h|
      it_behaves_like :valid_fill_in, h, 'Person'
    end

    describe 'Birthday' do
      When { fill_in 'person[birthday]', with: '27.05.1985' }
      When { click_button 'Зберегти Person' }

      describe 'brithdate is shown' do
        Then { expect(find('body')).to have_content('Birthday: 1985-05-27') }
      end

      it_behaves_like :alert_success_updated, 'Person'
    end

    describe 'Gender' do
      it_behaves_like :valid_select, 'Person', 'person[gender]', 'Чоловіча',  'Gender: Male'
      it_behaves_like :valid_select, 'Person', 'person[gender]', 'Жіноча',    'Gender: Female'
    end
  end

  context 'When values are invalid:' do
    [
      { field: 'person[telephones_attributes][0][phone]', value: '111' },
      { field: 'person[telephones_attributes][0][phone]', value: '+10632223344' },
      { field: 'person[email]', value: '@@.com@' }
    ].each do |h|
      describe h[:field] do
        When do
          fill_in(h[:field], with: h[:value])
          click_button('Зберегти Person')
        end

        Then { expect(find('body')).to have_selector('.alert-danger') }
        And  { expect(find('.has-error:not(.hidden)')).to have_selector('span.help-block') }
      end
    end
  end
end
