# require 'rails_helper'

describe JournalsController do
  describe 'not signed in' do
    Given(:params) { {} }

    context '#show' do
      When { get :show }

      it_behaves_like :not_authenticated
    end
  end

  describe 'signed in' do
    Given(:user) { create :person, roles: [create(:role, activities: activities)] }

    Given { sign_in user }

    describe 'with valid user' do
      describe 'GET #show' do
        Given(:activities) { ['paper_trail/version:show'] }

        When  { get :show }

        Then  { expect(response.status).to eq(200) }
      end
    end

    describe 'with invalid user' do
      Given(:activities) { ['some:some'] }

      describe 'GET #show' do
        When { get :show }

        it_behaves_like :not_authorized
      end
    end
  end
end
