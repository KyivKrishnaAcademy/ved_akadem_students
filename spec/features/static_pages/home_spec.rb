require 'spec_helper'

describe :home do
  Given { login_as_user }

  When { visit '/static_pages/home' }

  context 'should have the right title' do
    Then { expect(page).to have_title('Kyiv Vedic Akademy Students | Home') }
  end
end
