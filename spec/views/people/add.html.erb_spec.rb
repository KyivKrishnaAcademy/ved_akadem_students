require 'spec_helper'

describe "people/add.html.erb" do
  it "should have the right title" do
    visit '/people/add'
    expect(page).to have_title("Kiev Vedic Akademy DataBase | Add New Person")
  end
end
