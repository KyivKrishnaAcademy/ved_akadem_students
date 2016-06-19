require 'rails_helper'

describe AssignedCertTemplate do
  describe 'associations' do
    Then { is_expected.to belong_to(:academic_group) }
    Then { is_expected.to belong_to(:certificate_template) }
    Then { is_expected.to have_many(:certificates) }
  end

  describe 'validation' do
    Then { is_expected.to validate_presence_of(:academic_group) }
    Then { is_expected.to validate_presence_of(:certificate_template) }
    Then { is_expected.to validate_uniqueness_of(:academic_group_id).scoped_to(:certificate_template_id) }
    Then { is_expected.to validate_uniqueness_of(:certificate_template_id).scoped_to(:academic_group_id) }
  end

  describe 'set default for cert_id_prefix' do
    Given(:subject) { assigned_cert_template.cert_id_prefix }
    Given(:assigned_cert_template) { build :assigned_cert_template, cert_id_prefix: prefix }

    When { assigned_cert_template.save }

    context 'when not set' do
      Given(:prefix) { '' }
      Given(:group_title) { assigned_cert_template.academic_group.title }
      Given(:template_id) { assigned_cert_template.certificate_template_id }

      Then { is_expected.to eq("#{group_title}-#{template_id}-") }
      And  { is_expected.not_to eq(prefix) }
    end

    context 'when is set' do
      Given(:prefix) { 'some-prefix' }

      Then { is_expected.to eq(prefix) }
    end
  end
end
