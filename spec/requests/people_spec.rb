require 'spec_helper'

describe "People" do
  describe "New page" do
    it "can be gotten" do
      get new_person_path
      response.status.should be(200)
    end
  end
end
