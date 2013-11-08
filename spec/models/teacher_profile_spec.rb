require 'spec_helper'

describe TeacherProfile do
  it { should have_db_column(:description).of_type(:string) }
end
