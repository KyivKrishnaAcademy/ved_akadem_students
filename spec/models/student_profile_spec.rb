require 'rails_helper'

describe StudentProfile do
  describe 'associtations' do
    Then { expect(subject).to belong_to(:person) }
    Then { expect(subject).to have_many(:group_participations ).dependent(:destroy              ) }
    Then { expect(subject).to have_many(:akadem_groups        ).through(  :group_participations ) }
    Then { expect(subject).to have_many(:attendances          ).dependent(:destroy              ) }
    Then { expect(subject).to have_many(:class_schedules      ).through(  :attendances          ) }
  end
end
