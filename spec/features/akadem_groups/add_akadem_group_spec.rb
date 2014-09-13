require 'rails_helper'

describe 'Add akadem group:' do
  before do
    login_as_admin
    visit new_akadem_group_path
  end

  let(:fill_right) { fill_akadem_group_data }
  let(:fill_wrong) { fill_akadem_group_data group_name: '12-1' }
  let(:model)      { AkademGroup }
  let(:attr_name)  { :group_name }
  let(:locator)    { "#{the_m.group_name}" }

  it_behaves_like :adds_model
  it_behaves_like :not_adds_model
  it_behaves_like :link_in_flash

  def fill_akadem_group_data ag={}
    agf = build(:akadem_group, ag)
    fill_in 'akadem_group_group_name'       , with: (agf.group_name       )
    fill_in 'akadem_group_group_description', with: (agf.group_description)
    select (ag[:establ_date_1i]||'2009'     ).to_s, from: 'akadem_group_establ_date_1i'
    select (ag[:establ_date_2i]||'September').to_s, from: 'akadem_group_establ_date_2i'
    select (ag[:establ_date_3i]||'29'       ).to_s, from: 'akadem_group_establ_date_3i'
    agf
  end
end
