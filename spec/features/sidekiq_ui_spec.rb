# require 'rails_helper'

describe 'Sidekiq UI' do
  Given(:ui_path) { '/sidekiq' }

  describe 'unauthenticated' do
    When { visit ui_path }

    Then { expect(find('.alert-alert')).to have_content(I18n.t('devise.failure.unauthenticated')) }
  end

  context 'authenticated' do
    Given { login_as(person) }

    describe 'unauthorized' do
      Given(:person) { create :person }

      Then { expect { visit ui_path }.to raise_error(ActionController::RoutingError) }
    end

    describe 'authorized' do
      Given(:person) { create :person, roles: [create(:role, activities: ['sidekiq:admin'])] }

      When { visit ui_path }

      Then { expect(find('.navbar-brand')).to have_content('Sidekiq') }
    end
  end
end
