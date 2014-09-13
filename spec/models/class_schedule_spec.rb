require 'rails_helper'

describe ClassSchedule do
  describe 'associations' do
    Then { expect(subject).to belong_to(:course) }
    Then { expect(subject).to belong_to(:teacher_profile) }
    Then { expect(subject).to belong_to(:akadem_group) }
    Then { expect(subject).to belong_to(:classroom) }
    Then { expect(subject).to have_many(:attendances).dependent(:destroy) }
  end
end
