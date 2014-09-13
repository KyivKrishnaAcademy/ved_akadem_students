require 'rails_helper'

describe TeacherSpeciality do
  describe 'associations' do
    Then { expect(subject).to belong_to(:teacher_profile) }
    Then { expect(subject).to belong_to(:course) }
  end
end
