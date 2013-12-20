require 'spec_helper'

describe "akadem_groups/new" do
  before { visit new_akadem_group_path }

  subject { page }

  let(:title)   { "Add New Akadem Group" }
  let(:h1)      { "Add Akadem Group" }
  let(:action)  { 'new' }

  it_behaves_like "akadem group new and edit"
end
