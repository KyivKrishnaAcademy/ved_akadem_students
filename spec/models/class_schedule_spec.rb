require 'spec_helper'

describe ClassSchedule do
  it { should have_db_column(:date                ).of_type(:date   ) }
  it { should have_db_column(:course_id           ).of_type(:integer) }
  it { should have_db_column(:teacher_profile_id  ).of_type(:integer) }
  it { should have_db_column(:akadem_group_id     ).of_type(:integer) }
  it { should have_db_column(:classroom_id        ).of_type(:integer) }

  it { should belong_to(:course           ) }
  it { should belong_to(:teacher_profile  ) }
  it { should belong_to(:akadem_group     ) }
  it { should belong_to(:classroom        ) }
  it { should have_many(:attendances      ).dependent(:destroy              ) }
end
