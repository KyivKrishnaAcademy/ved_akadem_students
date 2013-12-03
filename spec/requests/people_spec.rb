require 'spec_helper'

describe "People" do
  after(:all) { Person.destroy_all }

  describe "New page" do
    it "can be gotten" do
      get new_person_path
      response.status.should be(200)
      response.should render_template(partial: '_person_form')
    end
  end

  describe "Show page" do
    it "can be gotten" do
      get person_path(create_person)
      response.status.should be(200)
    end
  end

  describe "Index page" do
    it "can be gotten" do
      get people_path
      response.status.should be(200)
    end
  end

  describe "Edit page" do
    it "can be gotten" do
      get edit_person_path(create_person)
      response.status.should be(200)
      response.should render_template(partial: '_person_form')
    end
  end
end
