require 'rails_helper'

describe 'akadem_groups/show' do
  Given(:ag_name) { 'ТВ99-1' }

  Given do
    login_as_admin
    @ag = create :akadem_group, {group_name: ag_name}
    visit akadem_group_path(@ag)
  end

  Then { expect(page).to have_title(full_title(ag_name)) }
  Then { expect(page).to have_selector('h1', text: ag_name) }

  describe 'group' do
    Then { expect(find('body')).to have_text("Group name: " << @ag.group_name) }
    And  { expect(find('body')).to have_text("Establishment date: " << @ag.establ_date.to_s) }
    And  { expect(find('body')).to have_text("Description: " << @ag.group_description) }
  end

  describe 'links' do
    Then { expect(find('body')).to have_link('Delete', href: akadem_group_path(@ag)) }
    And  { expect(find('body')).to have_link('Edit'  , href: edit_akadem_group_path(@ag)) }
  end
end
