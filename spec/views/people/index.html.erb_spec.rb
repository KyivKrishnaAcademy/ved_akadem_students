require 'spec_helper'

describe "people/index.html.erb" do
  let(:models_count) { 20 }

  before do
    models_count.times { create_person }
    visit people_path
  end

  after { Person.destroy_all }

  subject { page }

  it { should have_title(full_title("All People")) }

  it { should have_selector('h1', text: "People"        ) }
  it { should have_selector('th', text: "Name"          ) }
  it { should have_selector('th', text: "Surname"       ) }
  it { should have_selector('th', text: "Spiritual Name") }

  it { should have_selector('tr.person', count: models_count) }
end
