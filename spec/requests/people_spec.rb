require 'spec_helper'

describe "People" do
  after(:all) { Person.destroy_all }

  describe "New page" do
    it "can be gotten" do
      get new_person_path
      response.should render_template(partial: '_person_form')
    end
  end

  describe "Edit page" do
    it "can be gotten" do
      get edit_person_path(create_person)
      response.should render_template(partial: '_person_form')
    end
  end
end
