require 'rails_helper'

describe 'routes for StaticPages' do
  it { expect(get: '/static_pages/home' ).to route_to('static_pages#home' ) }
end
