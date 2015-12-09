require 'rails_helper'

describe AssignedCertTemplate do
  describe 'associations' do
    Then { is_expected.to belong_to(:academic_group) }
    Then { is_expected.to belong_to(:certificate_template) }
  end

  describe 'validation' do
    Then { is_expected.to validate_presence_of(:academic_group) }
    Then { is_expected.to validate_presence_of(:certificate_template) }
    Then { is_expected.to validate_uniqueness_of(:academic_group_id).scoped_to(:certificate_template_id) }
    Then { is_expected.to validate_uniqueness_of(:certificate_template_id).scoped_to(:academic_group_id) }
  end
end
