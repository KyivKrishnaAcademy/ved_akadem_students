require 'spec_helper'

feature "Edit akadem group:" do
  subject { page }

  before do
    visit akadem_group_path(create(:akadem_group))
    click_link "Edit"
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
