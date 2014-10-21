require 'rails_helper'

describe 'Footer' do
  Given { page.set_rack_session(locale: :uk) }

  When { visit root_path }

  Then { expect(find('footer')).to have_link(I18n.t('defaults.links.agreement'), href: '/privacy_agreement') }
end
