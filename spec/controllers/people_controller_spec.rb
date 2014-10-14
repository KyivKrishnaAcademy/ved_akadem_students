require 'rails_helper'

describe PeopleController do
  When { sign_in :person, create(:person, :admin) }

  describe "POST 'create'" do
    When { post :create, person: build(:person).attributes.merge(telephones_attributes: [build(:telephone).attributes]) }

    context 'on success' do
      context 'redirect and flash' do
        Then { expect(response.status).to redirect_to(action: :new) }
        And  { is_expected.to set_the_flash[:success] }
      end

      context '@person' do
        Then { expect(assigns(:person)).to be_a(Person)  }
        And  { expect(assigns(:person)).to be_persisted }
      end
    end

    context 'on failure' do
      Given { allow_any_instance_of(Person).to receive(:save).and_return(false) }

      context 'render' do
        Then  { expect(response.status).to render_template(:new) }
      end

      context '@person' do
        Then { expect(assigns(:person)).not_to be_persisted }
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
          expect_any_instance_of(Person).to receive(:update_attributes).with( 'emergency_contact' => 'params',
                                                                              'skip_password_validation' => true)

          update_model('emergency_contact' => 'params')
        end
      end

      context 'flash and redirect' do
        When { update_model }

        Then { is_expected.to set_the_flash[:success] }
        And  { expect(response.status).to redirect_to person }
      end
    end

    context 'on failure' do
      Given { allow_any_instance_of(Person).to receive(:save).and_return(false) }

      When  { update_model }

      Then  { expect(response.status).to render_template(:edit) }
    end
  end

  Given(:mod_params) do
    {
      name:               'Василий',
      spiritual_name:     'Сарва Сатья дас',
      middle_name:        'Тигранович',
      surname:            'Киселев',
      email:              'ssd@pamho.yes',
      gender:             true,
      birthday:           7200.days.ago.to_date,
      education:          'Брахмачарьи ашрам',
      work:               'ББТ',
      emergency_contact:  'Харе Кришна Харе Кришна Кришна Кришна Харе Харе',
      telephones_attributes:  [ id: nil,
                                phone: '+380 50 111 2233']
    }
  end

  it_behaves_like 'controller subclass', PeopleController::PersonParams, :person

  describe 'direct to crop path' do
    describe 'create' do
      Given (:person_attributes) { build(:person).attributes.merge(password: 'password',
                                                                   password_confirmation: 'password',
                                                                   telephones_attributes: { '0' => { phone: '+380 50 111 2233'}}) }

      context 'has photo' do
        When { post :create, person: person_attributes.merge(photo: 'test.png') }

        Then { expect(response.status).to redirect_to(crop_image_path(assigns(:person).id)) }
      end

      context 'has no photo' do
        When { post :create, person: person_attributes }

        Then { expect(response.status).to redirect_to(action: :new) }
      end
    end

    describe 'update' do
      Given { @person = create(:person) }
      Given (:person_attributes) { @person.attributes.merge(password: 'password',
                                                                    password_confirmation: 'password',
                                                                    telephones_attributes: { '0' => { phone: '+380 50 111 2233'}}) }

      context 'has photo' do
        When { patch :update, id: @person.id, person: person_attributes.merge(photo: 'test.png') }

        Then { expect(response.status).to redirect_to(crop_image_path(@person.id)) }
      end

      context 'has no photo' do
        When { patch :update, id: @person.id, person: person_attributes }

        Then { expect(response.status).to redirect_to(person_path(@person.id)) }
      end
    end
  end
end
