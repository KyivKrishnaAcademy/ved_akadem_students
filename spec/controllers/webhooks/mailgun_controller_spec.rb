# require 'rails_helper'

describe Webhooks::MailgunController do
  Given(:person) { create :person }
  Given(:person_email) { person.email }
  Given(:signature) { 'a302e0aeabdd876a09d81ca4438b251ec24a845c33677b6cc9ff79bb15965a5c' }
  Given(:event) { action }

  Given(:signature_object) do
    {
      timestamp: '1579497335',
      token: 'some-token-here',
      signature: signature
    }
  end

  Given(:event_data) do
    {
      recipient: person_email,
      event: event
    }
  end

  Given(:fire_the_action) do
    post action, format: :json, params: { 'signature': signature_object, 'event-data': event_data }
  end

  shared_examples :mailgun_webhook do |action_name, boolean_field_name|
    describe "##{action_name}" do
      Given(:action) { action_name }

      context 'user is not signed in' do
        Given(:signature) { 'wrong' }

        When { fire_the_action }

        Then { expect(response.status).to be(401) }
      end

      context 'wrong event' do
        Given(:event) { 'wrong' }

        When { fire_the_action }

        Then { expect(response.status).to be(406) }
      end

      context 'email not found' do
        Given(:person_email) { 'wrong@email.com' }

        Then { expect { fire_the_action }.not_to change { person.reload[boolean_field_name] } }
        And  { expect(response.status).to be(200) }
      end

      context 'marks as complained' do
        Then { expect { fire_the_action }.to change { person.reload[boolean_field_name] }.to(true) }
        And  { expect(response.status).to be(200) }
      end
    end
  end

  include_examples :mailgun_webhook, :complained, :spam_complain
  include_examples :mailgun_webhook, :failed, :fake_email
end
