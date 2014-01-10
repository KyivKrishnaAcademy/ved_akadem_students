require 'spec_helper'

describe "people/edit.html.erb" do
  before do
    @p = create_person(
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
    )
    visit edit_person_path(@p)
  end

  subject { page }

  let(:title)  { complex_name(@p, :t) }
  let(:h1)     { complex_name(@p) }
  let(:action) { 'edit' }

  it_behaves_like "person new and edit"

  describe "default values" do
    it { should have_selector('#person_telephone[value="380112223344"]'        ) }
    it { should have_selector('#person_spiritual_name[value="Dasa Das"]'       ) }
    it { should have_selector('#person_name[value="Ivan"]'                     ) }
    it { should have_selector('#person_middle_name[value="Petrovich"]'         ) }
    it { should have_selector('#person_surname[value="Жук"]'                   ) }
    it { should have_selector('#person_email[value="juke@ulr.net"]'            ) }
    it { should have_selector('#person_edu_and_work[value="где-то когда-то"]'  ) }
    it { should have_selector('#person_emergency_contact[value="дед Василий"]' ) }

    xit { should have_select('#person_gender', selected: 'Male'     ) }
    it { pending 'Test default value if gender = Female too' }

    it { should have_selector('#person_birthday_1i option[selected]', text: '1975'    ) }
    it { should have_selector('#person_birthday_2i option[selected]', text: 'January' ) }
    it { should have_selector('#person_birthday_3i option[selected]', text: '30'      ) }
  end
end
