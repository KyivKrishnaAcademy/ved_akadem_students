require 'spec_helper'

describe PeopleController do
  before(:all) { 5.times { create_person } }
  after(:all)  { Person.destroy_all        }

  it_behaves_like "POST 'create'", :person, Person
  it_behaves_like "GET"          , :person, Person, :new
  it_behaves_like "GET"          , :person, Person, :show
  it_behaves_like "GET"          , :person, Person, :edit
  it_behaves_like "GET"          , :people, Person, :index
  it_behaves_like "DELETE 'destroy'", Person

  let(:mod_params) do
    {
      name:               "Василий"               ,
      spiritual_name:     "Сарва Сатья дас"       ,
      middle_name:        "Тигранович"            ,
      surname:            "Киселев"               ,
      email:              "ssd@pamho.yes"         ,
      telephone:          "380112223344"          ,
      gender:             true                    ,
      birthday:           7200.days.ago.to_date   ,
      edu_and_work:       "ББТ"                   ,
      emergency_contact:  "Харе Кришна Харе Кришна Кришна Кришна Харе Харе"
    }
  end

  it_behaves_like "controller subclass", PeopleController::PersonParams, :person

  describe "PATCH 'update'" do
    def update_person(attribs=nil)
      p         = Person.last
      p.name    = "Василий"
      attribs ||= p.attributes
      patch :update, {id: p.to_param, person: attribs}
      p
    end

    context "on success" do
      it { expect{ update_person }.to change{ Person.last.name }.to("Василий") }

      it "receives .update_attributes" do
        Person.any_instance.should_receive(:update_attributes).with({ "name" => "params" })
        update_person({ "name" => "params" })
      end

      context do
        before(:each) { @p = update_person }

        it { response.should redirect_to @p    }
        it { should set_the_flash[:success]    }
      end
    end

    context "on failure" do
      before do
        Person.any_instance.stub(:save).and_return(false)
        @p = update_person
      end

      it { response.should render_template(:edit)}
    end
  end
end
