require 'rails_helper'

describe 'Add academic group:' do
  before do
    login_as_admin
    visit new_academic_group_path
  end

  let(:fill_right) { fill_academic_group_data }
  let(:fill_wrong) { fill_academic_group_data group_name: '12-1' }
  let(:model)      { AcademicGroup }
  let(:attr_name)  { :group_name }
  let(:locator)    { "#{the_m.group_name}" }

  it_behaves_like :adds_model
  it_behaves_like :not_adds_model
  it_behaves_like :link_in_flash

  %w(administrator praepostor curator).each do |admin_type|
    describe "autocomplete #{admin_type}", :js do
      Given { create :person, name: 'Synchrophazotrone' }

      When  { fill_right }
      When  { find("#academic_group_#{admin_type}").set('rophazotr') }
      When  { choose_autocomplete_result('rophazotr', "#academic_group_#{admin_type}") }
      When  { click_button 'Створити Academic group' }
      When  { find('.alert-success') }
      When  { visit edit_academic_group_path(AcademicGroup.last) }

      Then  { expect(find("#academic_group_#{admin_type}").value).to have_content('Synchrophazotrone') }
    end
  end

  def fill_academic_group_data ag={}
    agf = build(:academic_group, ag)
    fill_in 'academic_group_group_name'       , with: (agf.group_name       )
    fill_in 'academic_group_group_description', with: (agf.group_description)
    select (ag[:establ_date_1i]||'2010').to_s, from: 'academic_group_establ_date_1i'
    select (ag[:establ_date_2i]||'Вересня').to_s, from: 'academic_group_establ_date_2i'
    select (ag[:establ_date_3i]||'29').to_s, from: 'academic_group_establ_date_3i'
    agf
  end
end
