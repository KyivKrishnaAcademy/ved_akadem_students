require 'rails_helper'

describe 'academic_groups/edit' do
  let(:date) { '2013-09-28'.to_date }

  before do
    login_as_admin

    visit edit_academic_group_path(
      create(:academic_group,
             title: ag_name,
             group_description: 'some текст',
             establ_date: date)
    )
  end

  subject { page }

  let(:ag_name) { 'ТВ99-1' }

  it_behaves_like 'academic group new and edit', 'edit'

  describe 'default values' do
    it { is_expected.to have_selector('#academic_group_title[value="' << ag_name << '"]') }
    it { is_expected.to have_selector('#academic_group_group_description[value="some текст"]') }
    it { expect(find('input#academic_group_establ_date').value).to eq(I18n.l(date, format: :date_picker)) }
  end
end
