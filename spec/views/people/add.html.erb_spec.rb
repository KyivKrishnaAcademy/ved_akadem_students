require 'spec_helper'

describe "people/add.html.erb" do

  before { visit people_add_path }

  subject { page }

  it { should have_title("Kiev Vedic Akademy DataBase | Add New Person") }
  it { should have_selector('form.new_person') }
  it { should have_selector('label', text: "Name") }
  it { should have_selector('input#person_name') }
  it { should have_selector('input.btn') }

end
