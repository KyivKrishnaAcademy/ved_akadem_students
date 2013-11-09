require 'spec_helper'

describe TeacherProfile do
  it { should have_db_column(:description).of_type(:string) }

  it { should have_many(:teacher_specialities ).dependent(:destroy              ) }
  it { should have_many(:courses              ).through(  :teacher_specialities ) }
  it { should have_many(:class_schedules      ).dependent(:destroy              ) }
end
