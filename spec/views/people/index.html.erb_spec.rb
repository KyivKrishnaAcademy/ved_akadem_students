require 'spec_helper'

describe "people/index" do
  let(:models_count) { 20 }

  before(:all)  { models_count.times { create_person } }
  before(:each) { visit people_path }
  after (:all)  { Person.destroy_all }

  let(:title) { "All People" }
  let(:h1) { "People" }
  let(:row_class) { "person" }

  it_behaves_like "index.html", ["Name", "Surname", "Spiritual Name"]
end
