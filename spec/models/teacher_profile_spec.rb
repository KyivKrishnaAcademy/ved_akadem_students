require 'rails_helper'

describe TeacherProfile do
  describe 'associations' do
    Then { expect(subject).to belong_to(:person) }
    Then { expect(subject).to have_many(:teacher_specialities).dependent(:destroy) }
    Then { expect(subject).to have_many(:courses).through(:teacher_specialities) }
    Then { expect(subject).to have_many(:class_schedules).dependent(:destroy) }
  end
end
