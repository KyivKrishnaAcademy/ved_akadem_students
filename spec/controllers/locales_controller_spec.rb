require 'rails_helper'

describe LocalesController do
  Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

  When { get :toggle }

  describe 'redirects back' do
    Then { expect(response).to redirect_to('where_i_came_from') }
  end

  describe 'toggles locae' do
    Then { expect(session[:locale]).to eq(:ru) }

    describe 'toggles locale again' do
      When { get :toggle }

      Then { expect(session[:locale]).to eq(:uk) }
    end
  end
end
