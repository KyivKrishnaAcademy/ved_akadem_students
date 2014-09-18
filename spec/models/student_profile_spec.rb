require 'rails_helper'

describe StudentProfile do
  describe 'associtations' do
    Then { is_expected.to belong_to(:person) }
    Then { is_expected.to have_many(:group_participations ).dependent(:destroy              ) }
    Then { is_expected.to have_many(:akadem_groups        ).through(  :group_participations ) }
    Then { is_expected.to have_many(:attendances          ).dependent(:destroy              ) }
    Then { is_expected.to have_many(:class_schedules      ).through(  :attendances          ) }
  end
end
