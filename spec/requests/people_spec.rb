require 'spec_helper'

describe "People" do
  after(:all) { Person.destroy_all }

  describe "New page" do
    it "can be gotten" do
      get new_person_path
      response.status.should be(200)
    end
  end

  describe "Show page" do
    it "can be gotten" do
      p = FactoryGirl.create :person
      get person_path(p)
      response.status.should be(200)
    end
  end

  describe "Index page" do
    it "can be gotten" do
      get people_path
      response.status.should be(200)
    end
  end
end
