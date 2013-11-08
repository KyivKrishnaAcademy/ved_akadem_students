require 'spec_helper'

describe GroupParticipation do
  it { should have_db_column(:student_profile_id  ).of_type(:integer  ) }
  it { should have_db_column(:akadem_group_id     ).of_type(:integer  ) }
  it { should have_db_column(:join_date           ).of_type(:date     ) }
  it { should have_db_column(:leave_date          ).of_type(:date     ) }

  it { should belong_to(:student_profile ) }
  it { should belong_to(:akadem_group    ) }
end
