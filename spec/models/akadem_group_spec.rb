require 'spec_helper'

describe AkademGroup do
  describe "DB table" do
    it { should have_db_column(:group_name        ).of_type(:string ) }
    it { should have_db_column(:group_description ).of_type(:string ) }
    it { should have_db_column(:establ_date       ).of_type(:date   ) }
  end

  describe "associations" do
    it { should have_many(:group_participations ).dependent(:destroy              ) }
    it { should have_many(:student_profiles     ).through(  :group_participations ) }
    it { should have_many(:class_schedules      ).dependent(:destroy              ) }
  end

  describe "validation" do
    it { should validate_uniqueness_of(:group_name) }
    it { should validate_presence_of(  :group_name) }

    VALID_NAMES   = %w[ ШБ13-1 БШ12-4 ЗШБ11-1 ]
    INVALID_NAMES = %w[ 12-2 ШБ-1 БШ112 ШБ11- ]

    it "allows valid addresses" do
      VALID_NAMES.each do |name|
        should      allow_value(name).for(:group_name)
      end
    end

    it "disallows invalid names" do
      INVALID_NAMES.each do |name|
        should_not  allow_value(name).for(:group_name)
      end
    end
  end

  describe "before save processing" do
    it "upcases :group_name" do
      create_akadem_group(group_name: "шб13-1")
        .group_name.should == "ШБ13-1"
    end
  end
end
