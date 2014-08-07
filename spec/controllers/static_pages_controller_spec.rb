require 'spec_helper'

describe StaticPagesController do
  describe :home do
    When { get :home }

    context 'not signed in' do
      Then  { response.should redirect_to(controller: 'devise/sessions', action: :new) }
    end

    context 'signed in' do
      Given { sign_in :person, create(:person) }

      Then  { response.should be_success }
    end
  end
end
