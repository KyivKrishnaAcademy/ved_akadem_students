require 'spec_helper'

describe "people/new.html.erb" do
  before { visit new_person_path }

  subject { page }

  let(:title)  { "Add New Person" }
  let(:h1)     { "Add Person" }
  let(:action) { 'new' }

  it_behaves_like "person new and edit"
end
