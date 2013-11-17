require 'spec_helper'

describe "static_pages/home.html.erb" do
  it "should have the right title" do
    visit '/static_pages/home'
    expect(page).to have_title("Kiev Vedic Akademy DataBase | Home")
  end
end