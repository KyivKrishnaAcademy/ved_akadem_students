require 'rails_helper'

describe TeacherProfile do
  describe 'associations' do
    Then { is_expected.to belong_to(:person) }
    Then { is_expected.to have_many(:teacher_specialities).dependent(:destroy) }
    Then { is_expected.to have_many(:courses).through(:teacher_specialities) }
    Then { is_expected.to have_many(:class_schedules).dependent(:destroy) }
  end

  describe 'delegations' do
    Then { is_expected.to delegate_method(:complex_name).to(:person) }
  end
end
