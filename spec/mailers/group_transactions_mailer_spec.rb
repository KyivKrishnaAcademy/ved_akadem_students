require 'rails_helper'

describe GroupTransactionsMailer do
  describe 'leave_the_group' do
    Given(:student) { create :person }
    Given(:group) { create :academic_group, administrator: admin }
    Given(:admin) { create :person, spiritual_name: 'Sarvamahaguru das' }
    Given(:mail) { described_class.leave_the_group(group, student) }

    context 'admin has spiritual name' do
      Then { expect(mail.body.encoded).to match('Sarvamahaguru das') }
    end

    context 'admin has no spiritual name' do
      Given(:admin) { create :person, spiritual_name: '', name: 'Vasyl', surname: 'Pupkin' }

      Then { expect(mail.body.encoded).to match('Vasyl Pupkin') }
    end

    describe 'general' do
      Then { expect(mail.to).to eql([student.email]) }
    end
  end
end
