require 'spec_helper'

describe StudentProfile do
  SP_COLUMNS = {
    person_id:          :integer,
    questionarie:       :boolean,
    passport_copy:      :boolean,
    petition:           :boolean,
    photos:             :boolean,
    folder_in_archive:  :string ,
    active_student:     :boolean
  }

  SP_COLUMNS.each do |name, type|
    context ":" do 
      let(:name) { name }
      let(:type) { type }
      it_should_behave_like "have DB column of type"
    end
  end

  it { should belong_to(:person) }
  it { should have_many(:group_participations).dependent(:destroy) }
  it { should have_many(:akadem_groups).through(:group_participations) }
end
