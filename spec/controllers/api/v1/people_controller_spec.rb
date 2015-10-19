require 'rails_helper'

describe Api::V1::PeopleController do
  describe '#index' do
    context 'user not signed in' do
      Given { expect(Api::PeopleLoadingInteraction).not_to receive(:new) }

      When  { get :index, format: :json }

      Then  { expect(response.status).to be(401) }
    end

    context 'user signed in' do
      Given(:person) { create :person }

      Given { expect(Api::PeopleLoadingInteraction).to receive(:new) }

      When  { get :index, person.create_new_auth_token.merge(format: :json) }

      Then  { expect(response.status).to be(200) }
    end
  end
end
