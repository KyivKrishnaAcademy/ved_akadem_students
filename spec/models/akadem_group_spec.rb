require 'spec_helper'

describe AkademGroup do
  it { should have_db_column(:group_name        ).of_type(:string ) }
  it { should have_db_column(:group_description ).of_type(:string ) }
  it { should have_db_column(:establ_date       ).of_type(:date   ) }

  it { should have_many(:group_participations ).dependent(:destroy              ) }
  it { should have_many(:student_profiles     ).through(  :group_participations ) }
end
