require 'spec_helper'

describe PeopleController do
  after(:all) { Person.destroy_all }

  shared_examples "gets right person" do |action|
    before(:each) do
      @p = Person.last
      get "#{action}", id: @p
    end

    it { response.should be_success }
    it { assigns(:person).should eq(@p) }
  end

  describe "GET 'new'" do
    before(:each) { get 'new' }

    it { response.should be_success }
    it { assigns(:person).should be_a_new(Person) }
  end

  describe "POST 'create'" do
    before(:each) { @p = get_person.attributes }

    it do 
      post 'create' , person: @p
      response.should redirect_to(action: :new)
    end

    it "creates Person" do
      expect {
        post 'create' , person: @p
      }.to change{Person.count}.by(1)
    end

    it "don't creates Person" do
      attrib             = @p
      attrib[:telephone] = '123213'
      expect {
        post 'create' , person: attrib
      }.not_to change{Person.count}.by(1)
    end
  end

  context do
    before(:all) { 20.times { create_person } }

    describe "GET 'index'" do
      before(:each) { get 'index' }

      it { response.should be_success }
      it { assigns(:people).should eq(Person.all) }
    end

    describe "DELETE 'destroy'" do
      it "deletes person" do
        expect {
          delete 'destroy', id: Person.last.id
        }.to change{Person.count}.by(-1)
      end
    end

    describe "GET 'show'" do
      it_behaves_like 'gets right person', 'show'
    end

    describe "GET 'edit'" do
      it_behaves_like 'gets right person', 'edit'
    end

    describe "PATCH 'update'" do
      it "updates person right" do
        p       = Person.last
        p.name  = "Vasiliy"
        expect { patch 'update', id: p.id, person: p.attributes }
          .to change{ Person.find(p.id).name }
            .to("Vasiliy")
      end
    end
  end
end
