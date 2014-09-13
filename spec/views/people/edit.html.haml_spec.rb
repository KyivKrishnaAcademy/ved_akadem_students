require 'rails_helper'

describe 'people/edit.html.erb' do
  before do
    @admin = create(:person, :admin,
      telephones:     [build(:telephone, phone: '380112223344')],
      spiritual_name: 'Dasa Das'        ,
      name:           'Ivan'            ,
      middle_name:    'Petrovich'       ,
      surname:        'Жук'             ,
      email:          'juke@ulr.net'    ,
      edu_and_work:   'где-то когда-то' ,
      gender:         true              ,
      emergency_contact: 'дед Василий'  ,
      birthday: '1975-01-30'.to_date)
    login_as_admin(@admin)
    visit edit_person_path(@admin)
  end

  subject { page }

  let(:title)  { complex_name(@admin, :t) }
  let(:h1)     { complex_name(@admin) }
  let(:action) { 'edit' }

  it_behaves_like 'person new and edit'

  describe 'default values' do
    it { expect(subject).to have_selector('#person_telephones_attributes_0_phone[value="380112223344"]') }
    it { expect(subject).to have_selector('#person_spiritual_name[value="Dasa Das"]'       ) }
    it { expect(subject).to have_selector('#person_name[value="Ivan"]'                     ) }
    it { expect(subject).to have_selector('#person_middle_name[value="Petrovich"]'         ) }
    it { expect(subject).to have_selector('#person_surname[value="Жук"]'                   ) }
    it { expect(subject).to have_selector('#person_email[value="juke@ulr.net"]'            ) }
    it { expect(subject).to have_css('#person_edu_and_work', text: 'где-то когда-то'       ) }
    it { expect(subject).to have_selector('#person_emergency_contact[value="дед Василий"]' ) }
    it { expect(subject).to have_css('#person_gender option[selected="selected"]', text: 'Male') }
    it { expect(subject).to have_selector('#person_birthday_1i option[selected]' , text: '1975') }
    it { expect(subject).to have_selector('#person_birthday_2i option[selected]' , text: 'January') }
    it { expect(subject).to have_selector('#person_birthday_3i option[selected]' , text: '30') }

    context 'gender is Female' do
      Given { @admin.update_attribute(:gender, false) }

      When  { visit edit_person_path(@admin) }

      Then  { expect(subject).to have_css('#person_gender option[selected="selected"]', text: 'Female') }
    end
  end
end
