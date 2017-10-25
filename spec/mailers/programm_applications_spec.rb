require 'rails_helper'

describe ProgrammApplicationsMailer do
  describe 'submitted' do
    Given(:mail) { described_class.submitted(student, program) }
    Given(:student) { create(:person) }
    Given(:program) { create(:program, manager: manager) }
    Given(:manager) { create(:person) }

    describe 'renders the headers' do
      Then { expect(mail.subject).to match(/#{Regexp.escape(student.complex_name)}/) }
      And { expect(mail.to).to eq([manager.email]) }
    end

    describe 'renders the body' do
      Then { expect(mail.body.encoded).to match(/#{person_url(student)}/) }
    end
  end
end
