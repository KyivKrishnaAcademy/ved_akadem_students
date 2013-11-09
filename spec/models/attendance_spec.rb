require 'spec_helper'

describe Attendance do
  it { should have_db_column(:class_schedule_id   ).of_type(:integer) }
  it { should have_db_column(:student_profile_id  ).of_type(:integer) }
  it { should have_db_column(:presence            ).of_type(:boolean) }

  it { should belong_to(:student_profile ) }
  it { should belong_to(:class_schedule  ) }
end
