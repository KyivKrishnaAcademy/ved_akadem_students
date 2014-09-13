require 'rails_helper'

describe Telephone do
  describe 'association' do
    Then { expect(subject).to belong_to(:person) }
  end
end
