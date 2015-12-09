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
end
