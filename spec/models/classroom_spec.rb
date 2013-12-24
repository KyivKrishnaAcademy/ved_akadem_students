require 'spec_helper'

describe Classroom do
  describe "DB table" do
    it { should have_db_column(:location    ).of_type(:string) }
    it { should have_db_column(:description ).of_type(:string) }
    it { should have_db_column(:roominess   ).of_type(:integer) }
  end

  describe "association" do
    it { should have_many(:class_schedules ).dependent(:destroy ) }
  end
end
