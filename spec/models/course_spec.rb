require 'rails_helper'

describe Course do
  describe 'associations' do
    Then { is_expected.to have_many(:teacher_specialities).dependent(:destroy) }
    Then { is_expected.to have_many(:teacher_profiles).through(:teacher_specialities) }
    Then { is_expected.to have_many(:class_schedules).dependent(:destroy) }
  end
end
