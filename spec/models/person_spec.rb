require 'spec_helper'

describe Person do
  P_COLUMNS = {
    name:               :string   ,
    middle_name:        :string   ,
    surname:            :string   ,
    spiritual_name:     :string   ,
    telephone:          :integer  ,
    email:              :string   ,
    gender:             :boolean  ,
    birthday:           :date     ,
    emergency_contact:  :string   ,
    photo:              :text     ,
    profile_fullness:   :boolean  ,
    edu_and_work:       :text
  }

  P_COLUMNS.each do |name, type|
    context ":" do 
      let(:name) { name }
      let(:type) { type }
      it_should_behave_like "have DB column of type"
    end
  end

  it { should have_one(:student_profile).dependent(:destroy) }
end
