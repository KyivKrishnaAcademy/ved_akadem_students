require 'spec_helper'

describe PeopleHelper do
  describe '#complex_name' do
    Given { @person = create :person }

    describe 'full with spiritual name should be "sp_name (name m_name surname)"' do
      Then { expect(complex_name(@person)).to match(/\A#{@person.spiritual_name} \(#{@person.name} #{@person.middle_name} #{@person.surname}\)\z/) }
    end

    describe "title with spiritual name should be 'sp_name'" do
      Then { expect(complex_name(@person, true)).to match(/\A#{@person.spiritual_name}\z/) }
    end

    describe "full  without spiritual name should be 'name m_name surname'" do
      Given { @person.spiritual_name = "" }

      Then { expect(complex_name(@person)).to match(/\A#{@person.name} #{@person.middle_name} #{@person.surname}\z/) }
    end

    describe "title without spiritual name should be 'name surname'" do
      Given { @person.spiritual_name = "" }

      Then { expect(complex_name(@person, true)).to match(/\A#{@person.name} #{@person.surname}\z/) }
    end

    describe "with person=nil should be 'No such person'" do
      Given { @person = nil }

      Then { expect(complex_name(@person)).to match(/\ANo such person\z/) }
    end
  end
end
