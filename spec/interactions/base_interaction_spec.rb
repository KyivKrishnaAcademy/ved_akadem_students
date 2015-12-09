require 'rails_helper'

describe BaseInteraction do
  Given(:interaction) { BaseInteraction.new(user: :user, params: :params, request: :request) }

  describe 'init' do
    Then { expect(interaction.user).to be(:user) }
    And  { expect(interaction.params).to be(:params) }
  end

  describe '#as_json' do
    Then { expect{interaction.as_json}.to raise_error(StandardError, /should be overridden/) }
  end
end
