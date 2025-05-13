# require 'rails_helper'

describe Users::RegistrationsController do
  Given { request.env['devise.mapping'] = Devise.mappings[:person] }

  shared_examples_for :delete_person do
    Then { expect { delete :destroy }.to change(Person, :count).by(-1) }
  end

  describe 'destroy' do
    When { sign_in person }

    context 'person is not a student or teacher' do
      Given(:person) { create :person }

      include_examples :delete_person
    end

    context 'person is student' do
      Given(:person) { create :person, :student, email: 'some@example.com' }

      include_examples :delete_person
    end

    context 'person is teacher' do
      Given(:person) { create :person, :teacher, email: 'some@example.com' }

      include_examples :delete_person
    end
  end

  describe 'direct to crop path' do
    describe 'create' do
      Given(:person_attributes) do
        build(:person)
          .attributes
          .merge(
            password: 'password',
            password_confirmation: 'password',
            telephones_attributes: { '0' => { phone: '+380 50 111 2233' } }
          )
      end

      context 'has photo' do
        When { post :create, params: { person: person_attributes.merge(photo: 'test.png') } }

        Then { expect(response).to redirect_to(crop_image_path(assigns(:person).id)) }
      end

      context 'has no photo' do
        When { post :create, params: { person: person_attributes } }

        Then { expect(response).to redirect_to(root_path) }
      end
    end

    describe 'update' do
      Given(:person) { create :person }

      Given(:person_attributes) do
        person
          .attributes
          .merge(
            current_password: 'password',
            telephones_attributes: { '0' => { phone: '+380 50 111 2233' } }
          )
      end

      When { sign_in person }

      context 'has photo' do
        When { post :update, params: { id: person.id, person: person_attributes.merge(photo: 'test.png') } }

        Then { expect(response).to redirect_to(crop_image_path(person.id)) }
      end

      context 'has no photo' do
        When { post :update, params: { id: person.id, person: person_attributes } }

        Then { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
