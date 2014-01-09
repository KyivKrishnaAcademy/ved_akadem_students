require 'spec_helper'

feature "Edit akadem group:" do
  subject { page }

  before do
    visit akadem_group_path(create_akadem_group(
      group_name: 'БШ19-2'            ,
      group_description: 'some текст' ,
      establ_date: '2013-09-28'.to_date
    ))
    click_link "Edit"
  end

  describe "default values" do
    it { should have_selector('#akadem_group_group_name[value="БШ19-2"]'                        ) }
    it { should have_selector('#akadem_group_group_description[value="some текст"]'             ) }
    it { should have_selector('#akadem_group_establ_date_1i option[selected]', text: '2013'     ) }
    it { should have_selector('#akadem_group_establ_date_2i option[selected]', text: 'September') }
    it { should have_selector('#akadem_group_establ_date_3i option[selected]', text: '28'       ) }
  end

  context "When values are valid:" do
    [
      {field: 'Group name'        , value: 'БШ99-9'       , test_field: 'Group name: '              },
      {field: 'Group description' , value: 'Зис из э test', test_field: 'Description: Зис из э test'}
    ].each do |h|
      it_behaves_like :valid_fill_in, h, 'Akadem group'
    end

    describe "Establishment date" do
      it_behaves_like :valid_select_date, 'AkademGroup', 'establ_date', 'Establishment date: '
    end
  end

  context "When values are invalid:" do
    it_behaves_like :invalid_fill_in, {field: 'Group name', value: '12-2'}, 'Akadem group'
  end
end
