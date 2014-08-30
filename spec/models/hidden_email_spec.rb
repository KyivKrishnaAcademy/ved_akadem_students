require 'spec_helper'

describe HiddenEmail do
  describe 'collect_hidden_emails' do
    Given { create :person, email: 'admin@example.com', telephones: [create(:telephone, phone: '1111111111')] }
    Given { create :person, email: 'terminator@test.org', telephones: [create(:telephone, phone: '1111111111')] }
    Given { @emails = HiddenEmail.collect_hidden_emails('1111111111') }

    Then do
      @emails.first.count('*').should == 2
      @emails.first.should =~ /(\w|\*)+@example\.com/
      @emails.last.count('*').should == 5
      @emails.last.should =~ /(\w|\*)+@test\.org/
    end
  end
end
