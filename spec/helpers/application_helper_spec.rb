require 'spec_helper'

describe ApplicationHelper do
  describe "full_title" do
    it "should include the page title and base title" do
      full_title("foo").should =~ /^Kyiv Vedic Akademy DataBase | foo$/
    end

    it "should not include a bar for the home page" do
      full_title("").should =~ /^Kyiv Vedic Akademy DataBase$/
    end
  end
end