require 'rails_helper'

describe HiddenEmail do
  describe 'collect_hidden_emails' do
    Given { create :person, email: 'admin@example.com', telephones: [create(:telephone, phone: '(111) 111-11-11')] }
    Given { create :person, email: 'terminator@test.org', telephones: [create(:telephone, phone: '(111) 111-11-11')] }
    Given { @emails = HiddenEmail.collect_hidden_emails('(111) 111-11-11') }

    Then { expect(@emails.first.count('*')).to eq(2) }
    And  { expect(@emails.first).to match(/(\w|\*)+@example\.com/) }
    And  { expect(@emails.last.count('*')).to eq(5) }
    And  { expect(@emails.last).to match(/(\w|\*)+@test\.org/) }
  end
end
