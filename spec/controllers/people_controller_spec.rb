require 'spec_helper'

describe PeopleController do

  describe "GET 'add'" do
    it "returns http success" do
      get 'add'
      response.should be_success
    end

    it "person should be new" do
      get 'add'
      assigns(:person).should be_a_new(Person)
    end
  end

end
