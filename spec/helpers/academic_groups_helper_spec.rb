require 'rails_helper'

describe AcademicGroupsHelper do
  Given(:group) { create :academic_group }

  describe '#am_i_group_elder?' do
    Given(:person) { create :person }

    Given { allow(self).to receive(:current_person).and_return(person) }

    context 'student' do
      Given { person.create_student_profile.move_to_group(group) }

      context 'regular' do
        Then { expect(am_i_group_elder?(group)).to be(false) }
      end

      context 'praepostor' do
        Given { group.update(praepostor_id: person.id) }

        Then  { expect(am_i_group_elder?(group)).to be(true) }
      end
    end

    context 'curator' do
      Given { group.update(curator_id: person.id) }

      Then  { expect(am_i_group_elder?(group)).to be(true) }
    end

    context 'administrator' do
      Given { group.update(administrator_id: person.id) }

      Then  { expect(am_i_group_elder?(group)).to be(true) }
    end

    context 'not related' do
      Then  { expect(am_i_group_elder?(group)).to be(false) }
    end
  end
end
