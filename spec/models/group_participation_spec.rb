require 'spec_helper'

describe GroupParticipation do
  GP_COLUMNS = {
    student_profile_id:   :integer,
    akadem_group_id:      :integer,
    join_date:            :date   ,
    leave_date:           :date
  }

  GP_COLUMNS.each do |name, type|
    context ":" do 
      let(:name) { name }
      let(:type) { type }
      it_should_behave_like "have DB column of type"
    end
  end
end
