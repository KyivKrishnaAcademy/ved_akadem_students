require 'spec_helper'

describe "akadem_groups/show" do
  let(:ag_name) { "ТВ99-1" }

  before do
    @ag = create :akadem_group, {group_name: ag_name}
    visit akadem_group_path(@ag)
  end

  subject { page }

  it { should have_title(full_title(ag_name)) }
  it { should have_selector('h1', text: ag_name) }

  describe "group" do
    it { should have_text("Group name: " << @ag.group_name) }
    it { should have_text("Establishment date: " << @ag.establ_date.to_s) }
    it { should have_text("Description: " << @ag.group_description) }
  end

  describe "links" do
    it { should have_link('Delete', href: akadem_group_path(@ag)) }
    it { should have_link('Edit'  , href: edit_akadem_group_path(@ag)) }
  end
end
