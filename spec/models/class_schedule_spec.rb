require 'rails_helper'

describe ClassSchedule do
  describe 'associations' do
    Then { is_expected.to belong_to(:course) }
    Then { is_expected.to belong_to(:teacher_profile) }
    Then { is_expected.to have_many(:academic_group_schedules).dependent(:destroy) }
    Then { is_expected.to have_many(:academic_groups).through(:academic_group_schedules) }
    Then { is_expected.to belong_to(:classroom) }
    Then { is_expected.to have_many(:attendances).dependent(:destroy) }
  end

  describe 'validations' do
    describe 'generic' do
      Then { is_expected.to validate_presence_of(:course) }
      Then { is_expected.to validate_presence_of(:classroom) }
      Then { is_expected.not_to validate_presence_of(:teacher_profile) }
      Then { is_expected.not_to validate_presence_of(:academic_groups) }
      Then { is_expected.to validate_presence_of(:start_time) }
      Then { is_expected.to validate_presence_of(:finish_time) }
    end
  end
end
