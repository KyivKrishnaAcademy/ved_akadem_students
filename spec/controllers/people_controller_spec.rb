require 'spec_helper'

describe PeopleController do
  When { sign_in :person, create(:person, :admin) }

  describe "POST 'create'" do
    When { post :create, person: build(:person).attributes.merge(skip_password_validation: true) }

    context 'on success' do
      context 'redirect and flash' do
        Then { response.should redirect_to(action: :new) }
        And  { should set_the_flash[:success] }
      end

      context '@person' do
        Then { assigns(:person).should be_a(Person)  }
        And  { assigns(:person).should be_persisted }
      end
    end

    context 'on failure' do
      Given { Person.any_instance.stub(:save).and_return(false) }

      context 'render' do
        Then  { response.should render_template(:new) }
      end

      context '@person' do
        Then { assigns(:person).should_not be_persisted }
      end
    end
  end

  it_behaves_like "GET", :person, Person, :new
  it_behaves_like "GET", :person, Person, :show
  it_behaves_like "GET", :person, Person, :edit
  it_behaves_like "GET", :people, Person, :index
  it_behaves_like "DELETE 'destroy'", Person

  describe "PATCH 'update'" do |model, field|
    Given(:person) { create :person }

    def update_model(attributes = nil)
      person.emergency_contact = 'Какой-то текст'

      attributes ||= person.attributes.merge(skip_password_validation: true)

      patch :update, { id: person.id, person: attributes }
    end

    context 'on success' do
      context 'field chenged' do
        Then { expect{ update_model }.to change{ person[:emergency_contact] }.to('Какой-то текст') }
      end

      context 'receives .update_attributes' do
        Then do
          Person.any_instance.should_receive(:update_attributes).with('emergency_contact' => 'params',
                                                                      'skip_password_validation' => true)
          update_model('emergency_contact' => 'params')
        end
      end

      context 'flash and redirect' do
        Then { update_model; should set_the_flash[:success] }
        And  { update_model; response.should redirect_to person }
      end
    end

    context 'on failure' do
      Given { Person.any_instance.stub(:save).and_return(false) }
      When  { update_model }

      Then  { response.should render_template(:edit) }
    end
  end

  Given(:mod_params) do
    {
      name:               'Василий',
      spiritual_name:     'Сарва Сатья дас',
      middle_name:        'Тигранович',
      surname:            'Киселев',
      email:              'ssd@pamho.yes',
      telephone:          '380112223344',
      gender:             true,
      birthday:           7200.days.ago.to_date,
      edu_and_work:       'ББТ',
      emergency_contact:  'Харе Кришна Харе Кришна Кришна Кришна Харе Харе'
    }
  end

  it_behaves_like 'controller subclass', PeopleController::PersonParams, :person
end
