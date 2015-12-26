require 'rails_helper'

describe Certificate do
  describe 'associations' do
    Then { is_expected.to belong_to(:assigned_cert_template) }
    Then { is_expected.to belong_to(:student_profile) }
  end

  describe 'validation' do
    Then { is_expected.to validate_presence_of(:assigned_cert_template) }
    Then { is_expected.to validate_presence_of(:student_profile) }
  end

  describe 'set cert_id before save' do
    Given(:person) { create :person }
    Given(:profile) { person.create_student_profile }
    Given(:assigned_template) { create :assigned_cert_template }

    Given(:cert) do
      build :certificate, cert_id: cert_id,
                          student_profile_id: profile.id,
                          assigned_cert_template_id: assigned_template.id
    end

    context 'when not set' do
      Given(:cert_id) { '' }
      Given(:expected_id) { "#{assigned_template.cert_id_prefix}#{person.id}" }

      Then { expect { cert.save }.to change { cert.cert_id }.from(cert_id).to(expected_id) }
    end

    context 'when is set' do
      Given(:cert_id) { 'some-id' }

      Then { expect { cert.save }.not_to change { cert.cert_id } }
    end
  end
end
