require 'spec_helper'

describe Person do
  it { should have_db_column(:name              ).of_type(:string   ) }
  it { should have_db_column(:middle_name       ).of_type(:string   ) }
  it { should have_db_column(:surname           ).of_type(:string   ) }
  it { should have_db_column(:spiritual_name    ).of_type(:string   ) }
  it { should have_db_column(:telephone         ).of_type(:integer  ) }
  it { should have_db_column(:email             ).of_type(:string   ) }
  it { should have_db_column(:gender            ).of_type(:boolean  ) }
  it { should have_db_column(:birthday          ).of_type(:date     ) }
  it { should have_db_column(:emergency_contact ).of_type(:string   ) }
  it { should have_db_column(:photo             ).of_type(:text     ) }
  it { should have_db_column(:profile_fullness  ).of_type(:boolean  ) }
  it { should have_db_column(:edu_and_work      ).of_type(:text     ) }

  it { should have_one(:student_profile).dependent(:destroy) }
end
