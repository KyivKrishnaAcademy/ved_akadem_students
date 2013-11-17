require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "can be gotten" do
      get static_pages_home_path
      response.status.should be(200)
    end
  end

  describe "About page" do
    it "can be gotten" do
      get static_pages_about_path
      response.status.should be(200)
    end
  end
end
