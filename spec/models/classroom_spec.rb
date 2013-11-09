require 'spec_helper'

describe Classroom do
  it { should have_db_column(:location    ).of_type(:string) }
  it { should have_db_column(:description ).of_type(:string) }

  it { should have_many(:class_schedules ).dependent(:destroy ) }
end
