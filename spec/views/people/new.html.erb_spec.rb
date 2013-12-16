require 'spec_helper'

describe "people/new.html.erb" do
  before { visit new_person_path }

  subject { page }

  it { should have_title(full_title("Add New Person")) }
  it { should have_selector('h1', text: "Add Person") }
  it { should have_selector('form.new_person') }

  it_behaves_like "person form"
end
