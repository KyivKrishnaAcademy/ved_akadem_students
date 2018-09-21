require 'rails_helper'

describe GroupTransactionsMailer do
  Given(:student) { create :person }
  Given(:group) { create :academic_group, administrator: admin }
  Given(:admin) { create :person, diploma_name: 'Sarvamahaguru das' }

  shared_examples 'email general' do
    context 'admin has diploma name' do
      Then { expect(mail.body.encoded).to match('Sarvamahaguru das') }
    end

    context 'admin has no diploma name' do
      Given(:admin) { create :person, diploma_name: '', name: 'Vasyl', surname: 'Pupkin' }

      Then { expect(mail.body.encoded).to match('Vasyl Pupkin') }
    end

    describe 'general' do
      Then { expect(mail.to).to eql([student.email]) }
      Then { expect(mail.reply_to).to eql([admin.email]) }
    end
  end

  describe 'leave_the_group' do
    Given(:mail) { described_class.leave_the_group(group, student) }

    include_examples 'email general'

    Then { expect(mail.subject).to eq(I18n.t('mail.group.leave.subject', group_title: group.title)) }
  end

  describe 'join_the_group' do
    Given(:mail) { described_class.join_the_group(group, student) }

    include_examples 'email general'

    Then { expect(mail.body.encoded).to match(academic_group_url(group)) }
    Then { expect(mail.subject).to eq(I18n.t('mail.group.join.subject', group_title: group.title)) }
  end
end
