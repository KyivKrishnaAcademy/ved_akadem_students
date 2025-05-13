# require 'rails_helper'

describe AcademicGroupSchedule do
  describe 'associations' do
    Then { is_expected.to belong_to(:academic_group) }
    Then { is_expected.to belong_to(:class_schedule) }
  end

  describe 'validations' do
    Then { is_expected.to validate_uniqueness_of(:academic_group_id).scoped_to(:class_schedule_id) }
    Then { is_expected.to validate_uniqueness_of(:class_schedule_id).scoped_to(:academic_group_id) }
  end
end
