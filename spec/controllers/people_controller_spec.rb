require 'spec_helper'

describe PeopleController do

  describe "GET 'add'" do
    before(:each) { get 'add' }

    it { response.should be_success }
    it { assigns(:person).should be_a_new(Person) }
  end

  describe "POST 'create'" do
    after(:all) { Person.destroy_all }

    it do 
      post 'create' , person: get_person.attributes
      response.should redirect_to(action: :add)
    end

    it "should create Person" do
      expect {
        post 'create' , person: get_person.attributes
      }.to change{Person.count}.by(1)
    end

    it "should not create Person" do
      attrib = get_person.attributes
      attrib[:telephone] = '123213'
      expect {
        post 'create' , person: attrib
      }.not_to change{Person.count}.by(1)
    end
  end

end
