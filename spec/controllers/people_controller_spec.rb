require 'spec_helper'

describe PeopleController do
  after(:all) { Person.destroy_all }

  describe "GET 'new'" do
    before(:each) { get 'new' }

    it { response.should be_success }
    it { assigns(:person).should be_a_new(Person) }
  end

  describe "POST 'create'" do
    it do 
      post 'create' , person: get_person.attributes
      response.should redirect_to(action: :new)
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

  describe "GET 'show'" do
    it "should get right person" do
      p = FactoryGirl.create :person
      get 'show', id: p
      assigns(:person).should eq(p)
    end
  end

  describe "GET 'index'" do
    before { 20.times { FactoryGirl.create :person } }
    it "should get all people" do
      p = Person.all
      get 'index'
      assigns(:people).should eq(p)
    end
  end

  describe "DELETE 'destroy'" do
    before { FactoryGirl.create :person }
    it "should delete person" do
      expect {
        delete 'destroy', id: Person.last.id
      }.to change{Person.count}.by(-1)
    end
  end

  describe "GET 'edit'" do
    before { @p = FactoryGirl.create :person }
    it "should get right person" do
      p = FactoryGirl.create :person
      get 'edit', id: p
      assigns(:person).should eq(p)
    end 
  end

  describe "PATCH 'update'" do
    it "updates person right" do
      p = FactoryGirl.create :person
      p.name = "Vasiliy"
      expect { patch 'update', id: p.id, person: p.attributes }.to change{
        Person.find(p.id).name
      }.to("Vasiliy")
    end
  end
end
