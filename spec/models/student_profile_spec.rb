require 'spec_helper'

describe StudentProfile do
  it { should have_db_column(:person_id         ).of_type(:integer  ) }
  it { should have_db_column(:questionarie      ).of_type(:boolean  ) }
  it { should have_db_column(:passport_copy     ).of_type(:boolean  ) }
  it { should have_db_column(:petition          ).of_type(:boolean  ) }
  it { should have_db_column(:photos            ).of_type(:boolean  ) }
  it { should have_db_column(:folder_in_archive ).of_type(:string   ) }
  it { should have_db_column(:active_student    ).of_type(:boolean  ) }

  it { should belong_to(:person) }
  it { should have_many(:group_participations ).dependent(:destroy              ) }
  it { should have_many(:akadem_groups        ).through(  :group_participations ) }
end
