require 'rails_helper'

describe Course do
  describe 'associations' do
    Then { expect(subject).to have_many(:teacher_specialities).dependent(:destroy) }
    Then { expect(subject).to have_many(:teacher_profiles).through(:teacher_specialities) }
    Then { expect(subject).to have_many(:class_schedules).dependent(:destroy) }
  end
end
