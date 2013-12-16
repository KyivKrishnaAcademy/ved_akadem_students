require 'spec_helper'

describe PeopleHelper do
  describe "complex_name" do
    before(:all) { FactoryGirl.create(:person) }
    after(:all) { Person.destroy_all }
    before(:each) { @person = Person.first }

    it "full with spiritual name should be 'sp_name (name m_name surname)' " do
      complex_name(@person).should =~ /\A#{@person.spiritual_name} \(#{@person.name} #{@person.middle_name} #{@person.surname}\)\z/
    end

    it "title with spiritual name should be 'sp_name' " do
      complex_name(@person, true).should =~ /\A#{@person.spiritual_name}\z/
    end

    describe "full  without spiritual name should be 'name m_name surname'" do
      before { @person.spiritual_name = "" }
      it { complex_name(@person).should =~ /\A#{@person.name} #{@person.middle_name} #{@person.surname}\z/ }
    end

    describe "title without spiritual name should be 'name surname' " do
      before { @person.spiritual_name = "" }
      it { complex_name(@person, true).should =~ /\A#{@person.name} #{@person.surname}\z/ }
    end

    describe "with person=nil should be 'No such person'" do
      before { @person = nil }
      it { complex_name(@person).should =~ /\ANo such person\z/ }
    end
  end
end
