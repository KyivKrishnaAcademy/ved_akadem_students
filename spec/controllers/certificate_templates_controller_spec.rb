# require 'rails_helper'

describe CertificateTemplatesController do
  describe 'not signed in' do
    Given(:params) { {} }

    context '#index' do
      When { get :index }

      it_behaves_like :not_authenticated
    end

    context '#create' do
      When { post :create, params: params }

      it_behaves_like :not_authenticated
    end

    context '#new' do
      When { get :new }

      it_behaves_like :not_authenticated
    end

    context '#edit' do
      When { get :edit, params: { id: 1 } }

      it_behaves_like :not_authenticated
    end

    context '#update' do
      When { patch :update, params: { id: 1 } }

      it_behaves_like :not_authenticated
    end

    context '#destroy' do
      When { delete :destroy, params: { id: 1 } }

      it_behaves_like :not_authenticated
    end
  end

  describe 'signed in' do
    Given(:user) { create :person, roles: [create(:role, activities: activities)] }
    Given(:template) { create :certificate_template }

    Given { sign_in user }

    describe 'with invalid user' do
      Given(:activities) { ['some:some'] }

      describe 'GET #index' do
        When { get :index }

        it_behaves_like :not_authorized
      end

      describe 'GET #new' do
        When { get :new }

        it_behaves_like :not_authorized
      end

      describe 'GET #edit' do
        When { get :edit, params: { id: template.id } }

        it_behaves_like :not_authorized
      end

      describe 'POST #create' do
        Given(:action) do
          post(
            :create,
            params: {
              certificate_template: {
                title: 'some'
              }
            }
          )
        end

        context 'should not create' do
          Then { expect { action }.not_to change { CertificateTemplate.count } }
        end

        context 'redirects' do
          When { action }

          it_behaves_like :not_authorized
        end
      end

      describe 'PUT #update' do
        Given(:action) { put :update, params: { id: template.id, certificate_template: { title: 'some' } } }

        context 'should not update' do
          Then { expect { action }.not_to change { template.reload.title } }
        end

        context 'redirects' do
          When { action }

          it_behaves_like :not_authorized
        end
      end

      describe 'DELETE #destroy' do
        Given(:action) { delete :destroy, params: { id: template.id } }

        Given { template }

        context 'should not destroy' do
          Then { expect { action }.not_to change { CertificateTemplate.count } }
        end

        context 'redirects' do
          When { action }

          it_behaves_like :not_authorized
        end
      end
    end
  end
end
