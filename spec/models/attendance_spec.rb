require 'spec_helper'

describe Attendance do
  it { should have_db_column(:class_schedule_id   ).of_type(:integer) }
  it { should have_db_column(:student_profile_id  ).of_type(:integer) }
end
