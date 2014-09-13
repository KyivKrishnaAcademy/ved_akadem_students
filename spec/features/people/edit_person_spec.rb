require 'rails_helper'

describe 'Edit person:' do
  subject { page }

  before do
    login_as_admin
    visit person_path(create(:person, birthday: '2008-10-08'))
    click_link 'Edit'
  end

  context 'When values are valid:' do
    [
      {field: 'Spiritual name'   , value: 'AdiDasa dasa'  , test_field: 'Spiritual name: Adidasa Dasa' },
      {field: 'Name'             , value: 'алексей'       , test_field: 'Name: Алексей'                },
      {field: 'Middle name'      , value: 'иванович'      , test_field: 'Middle name: Иванович'        },
      {field: 'Surname'          , value: 'евгеньев'      , test_field: 'Surname: Евгеньев'            },
      {field: 'person[email]'    , value: 'alex@PAMHO.net', test_field: 'Email: alex@pamho.net'        },
      {field: 'Phone'            , value: '380692223344'  , test_field: 'Telephone 1: 380692223344'    },
      {field: 'person[edu_and_work]', value: 'some'       , test_field: 'Education, hobby, job: some'  },
      {field: 'Emergency contact', value: 'дядя Петя'     , test_field: 'Emergency contact: дядя Петя' }
    ].each do |h|
      it_behaves_like :valid_fill_in, h, 'Person'
    end

    describe 'Birthday' do
      it_behaves_like :valid_select_date, 'Person', 'birthday', 'Birthday: '
    end

    describe 'Gender' do
      it_behaves_like :valid_select, 'Person', 'Gender', 'Male'  , 'Gender: Male'
      it_behaves_like :valid_select, 'Person', 'Gender', 'Female', 'Gender: Female'
    end
  end

  context 'When values are invalid:' do
    [
      {field: 'Phone'         , value: '501112233'},
      {field: 'person[email]' , value: '@@.com@'   },
      {field: 'Name'          , value: ''          },
      {field: 'Surname'       , value: ''          }
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
