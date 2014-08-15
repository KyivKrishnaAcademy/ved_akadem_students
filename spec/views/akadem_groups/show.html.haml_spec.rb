require 'spec_helper'

describe 'akadem_groups/show' do
  Given(:ag_name) { 'ТВ99-1' }

  Given do
    login_as_admin
    @ag = create :akadem_group, {group_name: ag_name}
    visit akadem_group_path(@ag)
  end

  Then { page.should have_title(full_title(ag_name)) }
  Then { page.should have_selector('h1', text: ag_name) }

  describe 'group' do
    Then { find('body').should have_text("Group name: " << @ag.group_name) }
    And  { find('body').should have_text("Establishment date: " << @ag.establ_date.to_s) }
    And  { find('body').should have_text("Description: " << @ag.group_description) }
  end

  describe 'links' do
    Then { find('body').should have_link('Delete', href: akadem_group_path(@ag)) }
    And  { find('body').should have_link('Edit'  , href: edit_akadem_group_path(@ag)) }
  end
end
