require 'spec_helper'

feature "Edit person:" do
  subject { page }

  before do
    p = create :person, {username: 'test', password: 'password', password_confirmation: 'password'}
    visit new_person_session_path
    fill_in 'person_username', with: 'test'
    fill_in 'person_password', with: 'password'
    click_button 'Sign in'
    visit person_path(create(:person))
    click_link "Edit"
  end

  context "When values are valid:" do
    [
      {field: 'Spiritual name'   , value: 'AdiDasa dasa'  , test_field: 'Spiritual name: Adidasa Dasa' },
      {field: 'Name'             , value: 'алексей'       , test_field: 'Name: Алексей'                },
      {field: 'Middle name'      , value: 'иванович'      , test_field: 'Middle name: Иванович'        },
      {field: 'Surname'          , value: 'евгеньев'      , test_field: 'Surname: Евгеньев'            },
      {field: 'Email'            , value: 'alex@PAMHO.net', test_field: 'Email: alex@pamho.net'        },
      {field: 'Telephone'        , value: '380692223344'  , test_field: 'Telephone: 380692223344'      },
      {field: 'Education and job', value: 'some'          , test_field: 'Education, hobby, job: some'  },
      {field: 'Emergency contact', value: 'дядя Петя'     , test_field: 'Emergency contact: дядя Петя' }
    ].each do |h|
      it_behaves_like :valid_fill_in, h, 'Person'
    end

    describe "Birthday" do
      it_behaves_like :valid_select_date, 'Person', 'birthday', 'Birthday: '
    end

    describe "Gender" do
      it_behaves_like :valid_select, 'Person', 'Gender', 'Male'  , 'Gender: Male'
      it_behaves_like :valid_select, 'Person', 'Gender', 'Female', 'Gender: Female'
    end
  end

  context "When values are invalid:" do
    [
      {field: 'Telephone', value: '0501112233'},
      {field: 'Email'    , value: '@@.com@'   },
      {field: 'Name'     , value: ''          },
      {field: 'Surname'  , value: ''          }
    ].each do |h|
      it_behaves_like :invalid_fill_in, h, 'Person'
    end
  end
end
