require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "can be gotten" do
      get static_pages_home_path
      response.status.should be(200)
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("Kiev Vedic Akademy DataBase | Home")
    end
  end

  describe "About page" do
    it "can be gotten" do
      get static_pages_about_path
      response.status.should be(200)
    end

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("Kiev Vedic Akademy DataBase | About")
    end
  end
end
