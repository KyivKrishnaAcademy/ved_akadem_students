require 'spec_helper'

describe PeopleController do
  before(:all) { 5.times { create_person } }
  after(:all)  { Person.destroy_all        }

  it_behaves_like "POST 'create'", :person, Person
  it_behaves_like "GET"          , :person, Person, :new
  it_behaves_like "GET"          , :person, Person, :show
  it_behaves_like "GET"          , :person, Person, :edit
  it_behaves_like "GET"          , :people, Person, :index

  describe "DELETE 'destroy'" do
    def del_person; delete 'destroy', id: Person.last.id; end

    context "on success" do
      it { expect{ del_person }.to change(Person, :count).by(-1) }
      it { expect( del_person ).to redirect_to(action: :index)   }
      it { del_person; should set_the_flash[:success]            }
    end

    context "on failure" do
      before(:each) do
        Person.any_instance.stub_chain(:destroy, :destroyed?).and_return(false)
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it { expect{ del_person }.not_to change(Person, :count)     }
      it { expect(del_person).to redirect_to("where_i_came_from") }
      it { del_person; should set_the_flash[:error]               }
    end
  end

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

  describe PeopleController::PersonParams do
    subject {}
    describe ".filter" do
      it "returns the cleaned params" do
        user_params = {
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
        params = ActionController::Parameters.new(person: { foo: "foo" }.merge(user_params))

        permitted_params = PeopleController::PersonParams.filter(params)
        expect(permitted_params).to eq(user_params.with_indifferent_access)
      end
    end
  end
end
