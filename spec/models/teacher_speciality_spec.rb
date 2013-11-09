require 'spec_helper'

describe TeacherSpeciality do
  it { should have_db_column(:teacher_profile_id  ).of_type(:integer) }
  it { should have_db_column(:course_id           ).of_type(:integer) }
  it { should have_db_column(:since               ).of_type(:date   ) }

  it { should belong_to(:teacher_profile  ) }
  it { should belong_to(:course           ) }
end
