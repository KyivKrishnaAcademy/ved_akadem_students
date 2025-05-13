# require 'rails_helper'

describe TeacherSpeciality do
  describe 'associations' do
    Then { is_expected.to belong_to(:teacher_profile) }
    Then { is_expected.to belong_to(:course) }
  end

  describe 'validations' do
    Then { is_expected.to validate_uniqueness_of(:teacher_profile_id).scoped_to(:course_id) }
    Then { is_expected.to validate_uniqueness_of(:course_id).scoped_to(:teacher_profile_id) }
  end
end
