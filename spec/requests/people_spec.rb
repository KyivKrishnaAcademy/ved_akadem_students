require 'spec_helper'

describe "People" do
  describe "Add page" do
    it "can be gotten" do
      get people_add_path
      response.status.should be(200)
    end
  end
end
