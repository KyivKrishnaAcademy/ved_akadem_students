require 'rails_helper'

describe CertificateTemplatesController do
  describe 'not signed in' do
    Given(:params) { {} }

    it_behaves_like :failed_auth_crud, :not_authenticated

    context '#markup' do
      When { get :markup, id: 1 }

      it_behaves_like :not_authenticated
    end

    context '#background' do
      When { get :background, id: 1 }

      it_behaves_like :not_authenticated
    end

    context '#finish' do
      When { post :finish, id: 1 }

      it_behaves_like :not_authenticated
    end
  end

  describe 'with invalid user', :pending do
    Given!(:template) { create :certificate_template }

    Given { sign_in :person, create(:person) }

    describe 'GET #index' do
      When { get :index }

      it_behaves_like :not_authenticated
    end

    describe 'GET #show' do
      it_behaves_like :not_authenticated
    end

    describe 'GET #new' do
      it_behaves_like :not_authenticated
    end

    describe 'GET #edit' do
      it_behaves_like :not_authenticated
    end

    describe 'GET #markup' do
      it_behaves_like :not_authenticated
    end

    describe 'GET #background' do
      it_behaves_like :not_authenticated
    end

    describe 'POST #finish' do
      it_behaves_like :not_authenticated
    end

    describe 'POST #create' do
      it_behaves_like :not_authenticated
    end

    describe 'PUT #update' do
      it_behaves_like :not_authenticated
    end

    describe 'DELETE #destroy' do
      it_behaves_like :not_authenticated
    end
  end
end
