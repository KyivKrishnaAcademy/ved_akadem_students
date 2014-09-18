require 'rails_helper'

describe TeacherSpeciality do
  describe 'associations' do
    Then { is_expected.to belong_to(:teacher_profile) }
    Then { is_expected.to belong_to(:course) }
  end
end
