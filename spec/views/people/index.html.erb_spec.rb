require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "people/index" do
  let(:models_count) { 20 }

  before(:all)  { models_count.times { create_person } }
  before(:each) do
    login_as(Person.last, scope: :person)
    visit people_path
  end

  let(:title) { "All People" }
  let(:h1) { "People" }
  let(:row_class) { "person" }

  it_behaves_like "index.html", ["Name", "Surname", "Spiritual Name"]
end
