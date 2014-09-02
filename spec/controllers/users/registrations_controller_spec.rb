require 'spec_helper'

describe Users::RegistrationsController do
  Given { request.env['devise.mapping'] = Devise.mappings[:person] }

  shared_examples_for :hide_person do
    When { delete :destroy }

    Then do
      @person.reload
      @person.email.should =~ /^\w{6}.deleted.some@example.com$/
      @person.deleted.should be_true
    end
  end

  describe 'destroy' do
    When { sign_in :person, @person }

    context 'person is not a student or teacher' do
      Given { @person = create :person }

      Then  { expect { delete :destroy }.to change(Person, :count).by(-1) }
    end

    context 'person is student' do
      Given { @person = create :person, :student, email: 'some@example.com' }

      it_behaves_like :hide_person
    end

    context 'person is student' do
      Given { @person = create :person, :teacher, email: 'some@example.com' }

      it_behaves_like :hide_person
    end
  end

  describe 'direct to crop path' do
    context 'has photo' do
      When { post :create, person: build(:person).attributes.merge(password: 'password',
                                                                   password_confirmation: 'password',
                                                                   photo: 'test.png',
                                                                   telephones_attributes: { '0' => { phone: '1234567890'}}) }

      Then { response.should redirect_to(crop_image_path(assigns(:person).id)) }
    end

    context 'has no photo' do
      When { post :create, person: build(:person).attributes.merge(password: 'password',
                                                                   password_confirmation: 'password',
                                                                   telephones_attributes: { '0' => { phone: '1234567890'}}) }

      Then { response.should redirect_to(root_path) }
    end
  end
end
