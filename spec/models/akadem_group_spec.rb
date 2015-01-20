require 'rails_helper'

describe AkademGroup do
  describe 'associations' do
    Then { is_expected.to have_many(:group_participations).dependent(:destroy) }
    Then { is_expected.to have_many(:student_profiles).through(:group_participations) }
    Then { is_expected.to have_many(:class_schedules).dependent(:destroy) }
  end

  describe 'validation' do
    Given (:valid_names)   { %w[ ШБ13-1 БШ12-4 ЗШБ11-1 ] }
    Given (:invalid_names) { %w[ 12-2 ШБ-1 БШ112 ШБ11- ] }

    Then { is_expected.to validate_uniqueness_of(:group_name) }
    And  { is_expected.to validate_presence_of(:group_name) }
    And  do
      valid_names.each do |name|
        is_expected.to allow_value(name).for(:group_name)
      end
    end
    And  do
      invalid_names.each do |name|
        is_expected.not_to allow_value(name).for(:group_name)
      end
    end
  end

  describe 'upcases :group_name before save' do
    Then { expect(create(:akadem_group, {group_name: 'шб13-1'}).group_name).to eq('ШБ13-1') }
  end

  describe '#active_student_profiles' do
    Given { @group     = create :akadem_group }
    Given { @profile_1 = create(:person).create_student_profile }
    Given { @profile_2 = create(:person).create_student_profile }
    Given { @profile_1.move_to_group(@group) }
    Given { @profile_2.move_to_group(@group) }

    context 'all active' do
      Then { expect(@group.active_student_profiles).to match_array([@profile_1, @profile_2]) }
    end

    context 'there is inactive' do
      Given { @profile_2.remove_from_groups }
      Then  { expect(@group.active_student_profiles).to match_array([@profile_1]) }
    end
  end
end
