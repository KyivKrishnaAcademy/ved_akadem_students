require 'spec_helper'

describe "akadem_groups/index" do
  let(:models_count) { 20 }

  before(:all)  { models_count.times { create :akadem_group } }
  before(:each) { visit akadem_groups_path }

  let(:title) { "All Akadem Groups" }
  let(:h1) { "Akadem Groups" }
  let(:row_class) { "akadem_group" }

  it_behaves_like "index.html", ["Name", "Estbalished", "Description"]
end
