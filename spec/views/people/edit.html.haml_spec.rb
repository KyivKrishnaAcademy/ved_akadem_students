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
      education:      'где-то когда-то' ,
      work:           'никогда'         ,
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
    context 'gender is Male' do
      Then { is_expected.to have_selector('#person_telephones_attributes_0_phone[value="380112223344"]') }
      And  { is_expected.to have_selector('#person_spiritual_name[value="Dasa Das"]') }
      And  { is_expected.to have_selector('#person_name[value="Ivan"]') }
      And  { is_expected.to have_selector('#person_middle_name[value="Petrovich"]') }
      And  { is_expected.to have_selector('#person_surname[value="Жук"]') }
      And  { is_expected.to have_selector('#person_email[value="juke@ulr.net"]') }
      And  { is_expected.to have_css('#person_education', text: 'где-то когда-то') }
      And  { is_expected.to have_css('#person_work', text: 'никогда') }
      And  { is_expected.to have_selector('#person_emergency_contact[value="дед Василий"]') }
      And  { is_expected.to have_css('#person_gender option[selected="selected"]', text: 'Male') }
      And  { expect(find('#datepicker[name="person[birthday]"]').value).to eq('1975-01-30') }
    end

    context 'gender is Female' do
      Given { @admin.update_attribute(:gender, false) }

      When  { visit edit_person_path(@admin) }

      Then  { is_expected.to have_css('#person_gender option[selected="selected"]', text: 'Female') }
    end
  end
end
