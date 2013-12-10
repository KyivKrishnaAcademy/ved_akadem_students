require 'spec_helper'

describe PeopleController do
  after(:all) { Person.destroy_all }

  shared_examples "gets right person" do |action|
    before(:each) do
      @p = Person.last
      get "#{action}", id: @p
    end

    it { response.should be_success     }
    it { assigns(:person).should eq(@p) }
  end

  describe "GET 'new'" do
    before(:each) { get 'new' }

    it { response.should be_success               }
    it { assigns(:person).should be_a_new(Person) }
  end

  describe "POST 'create'" do
    describe "with valid params" do
      before(:each) { post :create, person: get_person.attributes }

      it { response.should redirect_to(action: :new) }
      it { assigns(:person).should be_a(Person)      }
      it { assigns(:person).should be_persisted      }
      it { flash[:success].should_not be_nil         }
    end

    describe "with invalid params" do
      before(:each) do
        Person.any_instance.stub(:save).and_return(false)
        post :create, person: get_person.attributes
      end

      it { response.should render_template(:new)    }
      it { assigns(:person).should_not be_persisted }
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
      def del_person; delete 'destroy', id: Person.last.id; end

      describe "deletion success" do
        it { expect{ del_person }.to change(Person, :count).by(-1) }
        it { expect( del_person ).to redirect_to(action: :index)   }
        it { del_person; flash[:success].should_not be_nil          }
      end

      describe "deletion failure" do
        before(:each) do
          Person.any_instance.stub(:destroyed?).and_return(false)
          request.env["HTTP_REFERER"] = "where_i_came_from"
        end
        
        it { expect(del_person).to redirect_to("where_i_came_from") }
        it { del_person; flash[:error].should_not be_nil            }
      end
    end

    describe "GET 'show'" do
      it_behaves_like 'gets right person', 'show'
    end

    describe "GET 'edit'" do
      it_behaves_like 'gets right person', 'edit'
    end

    describe "PATCH 'update'" do
      def update_person(attribs=nil)
        p         = Person.last
        p.name    = "Василий"
        attribs ||= p.attributes
        patch :update, {id: p.to_param, person: attribs}
        p
      end

      describe "with valid params" do
        it { expect{ update_person }.to change{ Person.last.name }.to("Василий") }

        it "updates with params" do
          Person.any_instance.should_receive(:update_attributes).with({ "name" => "params" })
          update_person({ "name" => "params" })
        end

        context do
          before(:each) { @p = update_person }

          it { response.should redirect_to @p    }
          it { assigns(:person).should eq(@p)    }
          it { flash[:success].should_not be_nil }
        end
      end

      describe "with invalid params" do
        before(:each) do
          Person.any_instance.stub(:save).and_return(false)
          @p = update_person
        end

        it { assigns(:person).should eq(@p)        }
        it { response.should render_template(:edit)}
      end
    end
  end
end
