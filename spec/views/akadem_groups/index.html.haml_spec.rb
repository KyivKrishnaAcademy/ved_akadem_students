require 'spec_helper'

describe "akadem_groups/index" do
  let(:models_count) { 20 }

  before(:all)  { models_count.times { create_akadem_group } }
  before(:each) { visit akadem_groups_path }
  after (:all)  { AkademGroup.destroy_all }

  let(:title) { "All Akadem Groups" }
  let(:h1) { "Akadem Groups" }
  let(:row_class) { "ag" }

  it_behaves_like "index.html", ["Name", "Estbalished", "Description"]
end
