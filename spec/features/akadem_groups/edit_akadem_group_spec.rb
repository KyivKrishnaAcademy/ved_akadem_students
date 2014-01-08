require 'spec_helper'

feature "Edit akadem group:" do
  subject { page }

  before do
    visit akadem_group_path(create_akadem_group)
    click_link "Edit"
  end

  shared_examples :alert_success do
    scenario { should have_selector('.alert-success', text: 'Akadem group was successfully updated.') }
  end

  context "When values are valid:" do
    # Text fields
    [
      {field: 'Group name'        ,value: 'БШ99-9'       , test_field: 'Group name: ' },
      {field: 'Group description' ,value: 'Зис из э test', test_field: 'Description: '}
    ].each do |h|
      describe h[:field] do
        let(:field) { h[:field] }
        let(:value) { h[:value] }

        before do
          fill_in field, with: value
          click_button "Update Akadem group"
        end

        scenario { should have_content("#{h[:test_field]}#{h[:value]}") }
        it_behaves_like :alert_success
      end
    end

    # Drop-down lists
    describe "Establishment date" do
      before do
        select '2016', from: 'akadem_group[establ_date(1i)]'
        select 'May' , from: 'akadem_group[establ_date(2i)]'
        select '27'  , from: 'akadem_group[establ_date(3i)]'
        click_button "Update Akadem group"
      end

      scenario { should have_content("Establishment date: 2016-05-27") }
      it_behaves_like :alert_success
    end
  end

  context "When values are valid:" do
    describe "Group name" do
      before do
        fill_in 'Group name', with: '12-2'
        click_button "Update Akadem group"
      end

      scenario { should have_selector('#error_explanation .alert-danger', text: 'The form contains 1 error.') }
      scenario { should have_selector('#error_explanation ul li', text: 'Group name is invalid') }
    end
  end
end
