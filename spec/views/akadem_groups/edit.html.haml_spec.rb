require 'spec_helper'

describe "akadem_groups/edit" do
  before do
    visit edit_akadem_group_path(
      create_akadem_group(
        group_name: ag_name             ,
        group_description: 'some текст' ,
        establ_date: '2013-09-28'.to_date
      )
    )
  end

  subject { page }

  let(:ag_name) { "ТВ99-1" }
  let(:title)   { ag_name }
  let(:h1)      { ag_name }
  let(:action)  { 'edit' }

  it_behaves_like "akadem group new and edit"

  describe "default values" do
    it { should have_selector('#akadem_group_group_name[value="' << ag_name << '"]'             ) }
    it { should have_selector('#akadem_group_group_description[value="some текст"]'             ) }
    it { should have_selector('#akadem_group_establ_date_1i option[selected]', text: '2013'     ) }
    it { should have_selector('#akadem_group_establ_date_2i option[selected]', text: 'September') }
    it { should have_selector('#akadem_group_establ_date_3i option[selected]', text: '28'       ) }
  end
end
