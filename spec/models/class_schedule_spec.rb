require 'rails_helper'

describe ClassSchedule do
  describe 'associations' do
    Then { is_expected.to belong_to(:course) }
    Then { is_expected.to belong_to(:teacher_profile) }
    Then { is_expected.to belong_to(:academic_group) }
    Then { is_expected.to belong_to(:classroom) }
    Then { is_expected.to have_many(:attendances).dependent(:destroy) }
  end
end
