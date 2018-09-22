require 'rails_helper'

describe ApplicationHelper do
  describe '#full_title' do
    it 'should include the page title and base title' do
      expect(full_title('foo')).to eq("foo | #{t(:application_title)}")
    end

    it 'should not include a bar for the home page' do
      expect(full_title('')).to eq(t(:application_title))
    end
  end

  describe '#complex_name' do
    Given(:person) { create :person }

    describe 'full with diploma name should be "sp_name (name m_name surname)"' do
      Given { person.update(diploma_name: 'Ololo') }

      Then do
        expect(complex_name(person))
          .to match(/\AOlolo \(#{person.surname} #{person.name} #{person.middle_name}\)\z/)
      end
    end

    describe "title with diploma name should be 'diploma_name'" do
      Given { person.update(diploma_name: 'Ololo') }

      Then { expect(complex_name(person, true)).to match(/\AOlolo\z/) }
    end

    describe "full without diploma name should be 'name m_name surname'" do
      Given { person.update(diploma_name: '') }

      Then { expect(complex_name(person)).to match(/\A#{person.surname} #{person.name} #{person.middle_name}\z/) }
    end

    describe "title without diploma name should be 'name surname'" do
      Given { person.diploma_name = '' }

      Then { expect(complex_name(person, true)).to match(/\A#{person.surname} #{person.name}\z/) }
    end

    describe "with person=nil should be 'No such person'" do
      Given(:person) { nil }

      Then { expect(complex_name(person)).to match(/\ANo such person\z/) }
    end
  end
end
