require 'rails_helper'

describe LocalesController do
  Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

  Given(:user) { create :person, locale: :ru }
  When { sign_in :person, user }

  When { get :toggle }

  describe 'redirects back' do
    Then { expect(response).to redirect_to('where_i_came_from') }
  end

  describe 'toggles locale' do

    Then { expect(user.reload.locale).to eq(:uk) }

    describe 'toggles locale again' do
      When { get :toggle }
      Then { expect(user.reload.locale).to eq(:ru) }
    end
  end

  after do
    session.delete(:locale)
    I18n.locale = :uk
  end
end
