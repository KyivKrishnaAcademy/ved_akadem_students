require 'rails_helper'

describe 'Footer' do
  When { visit root_path }

  Then { expect(find('footer')).to have_link(I18n.t('defaults.links.agreement'), href: '/privacy_agreement') }
end
