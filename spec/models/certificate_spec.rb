require 'rails_helper'

describe Certificate do
  describe 'associations' do
    Then { is_expected.to belong_to(:assigned_cert_template) }
    Then { is_expected.to belong_to(:student_profile) }
  end

  describe 'validation' do
    Then { is_expected.to validate_presence_of(:assigned_cert_template) }
    Then { is_expected.to validate_presence_of(:student_profile) }

    context 'uniqueness of' do
      # Foreign key constraint workaround
      # https://github.com/thoughtbot/shoulda-matchers/issues/682
      Given(:sp_1) { create :student_profile }
      Given(:sp_2) { create :student_profile }
      Given(:act_1) { create :assigned_cert_template }
      Given(:act_2) { create :assigned_cert_template }

      Given!(:cert_2) { create :certificate, student_profile: sp_1, assigned_cert_template: act_2 }

      context 'assigned_cert_template_id scoped to student_profile_id' do
        Given!(:cert_1) { create :certificate, student_profile: sp_1, assigned_cert_template: act_1 }

        When { cert_1.update(assigned_cert_template_id: act_2.id) }

        Then { expect(cert_1.errors).to include(:assigned_cert_template_id) }
      end

      context 'student_profile_id scoped to assigned_cert_template_id' do
        Given!(:cert_3) { create :certificate, student_profile: sp_2, assigned_cert_template: act_2 }

        When { cert_2.update(student_profile_id: sp_2.id) }

        Then { expect(cert_2.errors).to include(:student_profile_id) }
      end
    end
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
