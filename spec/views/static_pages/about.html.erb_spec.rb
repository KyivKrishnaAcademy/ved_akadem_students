require 'spec_helper'

describe "static_pages/about.html.erb" do
  it "should have the right title" do
    visit '/static_pages/about'
    expect(page).to have_title("Kyiv Vedic Akademy Students | About")
  end
end
