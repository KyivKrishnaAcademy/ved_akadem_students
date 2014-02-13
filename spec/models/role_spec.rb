require 'spec_helper'

describe Role do
  describe "DB table" do
    it { should have_db_column(:name      ).of_type(:string) }
    it { should have_db_column(:activities).of_type(:string) }
  end

  describe "association" do
    it { should have_and_belong_to_many(:people) }
  end

  describe "validations" do
    it { should validate_presence_of(:name      ) }
    it { should validate_presence_of(:activities) }

    it { should ensure_length_of(:name      ).is_at_most(30) }
  end
end
