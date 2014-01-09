require 'spec_helper'

feature "Edit person:" do
  subject { page }

  before do
    visit person_path(create_person(
      telephone:      '380112223344'    ,
      spiritual_name: 'Dasa Das'        ,
      name:           'Ivan'            ,
      middle_name:    'Petrovich'       ,
      surname:        'Жук'             ,
      email:          'juke@ulr.net'    ,
      edu_and_work:   'где-то когда-то' ,
      gender:         true              ,
      emergency_contact: 'дед Василий'  ,
      birthday: '1975-01-30'.to_date
    ))
    click_link "Edit"
  end

  describe "default values" do
    it { should have_selector('#person_telephone[value="380112223344"]'        ) }
    it { should have_selector('#person_spiritual_name[value="Dasa Das"]'       ) }
    it { should have_selector('#person_name[value="Ivan"]'                     ) }
    it { should have_selector('#person_middle_name[value="Petrovich"]'         ) }
    it { should have_selector('#person_surname[value="Жук"]'                   ) }
    it { should have_selector('#person_email[value="juke@ulr.net"]'            ) }
    it { should have_selector('#person_edu_and_work[value="где-то когда-то"]'  ) }
    it { should have_selector('#person_emergency_contact[value="дед Василий"]' ) }

    it { should have_selector('#person_birthday_1i option[selected]', text: '1975'    ) }
    it { should have_selector('#person_birthday_2i option[selected]', text: 'January' ) }
    it { should have_selector('#person_birthday_3i option[selected]', text: '30'      ) }
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
