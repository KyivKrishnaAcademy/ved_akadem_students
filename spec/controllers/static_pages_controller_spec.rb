# require 'rails_helper'
include Rails.application.routes.url_helpers

describe StaticPagesController do
  describe 'home' do
    When { get :home }

    context 'not signed in' do
      Then  { expect(response).to redirect_to(new_person_session_path) }
    end

    context 'signed in' do
      Given { sign_in create(:person) }

      Then  { expect(response).to have_http_status(:ok) }
    end
  end
end
