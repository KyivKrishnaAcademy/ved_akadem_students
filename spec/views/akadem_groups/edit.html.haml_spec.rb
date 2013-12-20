require 'spec_helper'

describe "akadem_groups/edit" do
  before do
    ag = create_akadem_group(group_name: ag_name)
    visit edit_akadem_group_path(ag)
  end

  after(:all) { AkademGroup.destroy_all}

  subject { page }

  let(:ag_name) { "ТВ99-1" }
  let(:title)   { ag_name }
  let(:h1)      { ag_name }
  let(:action)  { 'edit' }

  it_behaves_like "akadem group new and edit"
end
