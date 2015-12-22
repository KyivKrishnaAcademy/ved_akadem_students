require 'rails_helper'

describe CertificateTemplate do
  describe 'associations' do
    Then { is_expected.to have_many(:assigned_cert_templates).dependent(:destroy) }
    Then { is_expected.to have_many(:academic_groups).through(:assigned_cert_templates) }
  end

  describe 'validation' do
    Then { is_expected.to validate_presence_of(:title) }
    Then { is_expected.to validate_presence_of(:background) }
  end

  describe '.not_assigned_to' do
    Given!(:group_1) { create :academic_group }
    Given!(:group_2) { create :academic_group }
    Given!(:group_3) { create :academic_group }
    Given!(:template_1) { create :certificate_template, title: 'C' }
    Given!(:template_2) { create :certificate_template, title: 'A' }
    Given!(:template_3) { create :certificate_template, title: 'B' }

    Given { create :certificate_template, title: 'Not ready' }
    Given { [template_1, template_2, template_3].each { |t| t.ready! } }
    Given { create :assigned_cert_template, academic_group: group_1, certificate_template: template_1 }
    Given { create :assigned_cert_template, academic_group: group_2, certificate_template: template_2 }

    Given(:expected_1) { [template_2.id, template_3.id] }
    Given(:expected_2) { [template_3.id, template_1.id] }
    Given(:expected_3) { [template_2.id, template_3.id, template_1.id] }

    Then  { expect(described_class.not_assigned_to(group_1.id).pluck(:id)).to eq(expected_1) }
    Then  { expect(described_class.not_assigned_to(group_2.id).pluck(:id)).to eq(expected_2) }
    Then  { expect(described_class.not_assigned_to(group_3.id).pluck(:id)).to eq(expected_3) }
  end
end
