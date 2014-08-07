require 'spec_helper'

describe LocalesController do
  Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

  When { get :toggle }

  describe 'redirects back' do
    Then { response.should redirect_to('where_i_came_from') }
  end

  describe 'toggles locae' do
    Then { session[:locale].should == :ru }

    describe 'toggles locale again' do
      When { get :toggle }

      Then { session[:locale].should == :uk }
    end
  end
end
