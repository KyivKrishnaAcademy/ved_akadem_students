require 'rails_helper'

describe AcademicGroup do
  describe 'associations' do
    Then { is_expected.to have_many(:group_participations).dependent(:destroy) }
    Then { is_expected.to have_many(:student_profiles).through(:group_participations) }
    Then { is_expected.to have_many(:academic_group_schedules).dependent(:destroy) }
    Then { is_expected.to have_many(:class_schedules).through(:academic_group_schedules) }
  end

  describe 'validation' do
    Given (:valid_names)   { %w(ШБ13-1 БШ12-4 ЗШБ11-1) }
    Given (:invalid_names) { %w(12-2 ШБ-1 БШ112 ШБ11-) }

    Then { is_expected.to validate_uniqueness_of(:title) }
    And  { is_expected.to validate_presence_of(:title) }
    And  do
      valid_names.each do |name|
        is_expected.to allow_value(name).for(:title)
      end
    end
    And  do
      invalid_names.each do |name|
        is_expected.not_to allow_value(name).for(:title)
      end
    end
  end

  describe 'upcases :title before save' do
    Then { expect(create(:academic_group, {title: 'шб13-1'}).title).to eq('ШБ13-1') }
  end

  describe '#active_students' do
    Given(:group) { create :academic_group }
    Given(:person_c) { create(:person, spiritual_name: nil, surname: 'C' ) }
    Given(:person_b) { create(:person, spiritual_name: 'Bhakta das' ) }
    Given(:person_a) { create(:person, spiritual_name: nil, surname: 'A' ) }
    Given { person_a.create_student_profile.move_to_group(group) }
    Given { person_b.create_student_profile.move_to_group(group) }
    Given { person_c.create_student_profile.move_to_group(group) }

    context 'all active' do
      Then { expect(group.active_students).to eq([person_a, person_b, person_c]) }
    end

    context 'there is inactive' do
      Given { person_b.student_profile.remove_from_groups }

      context 'for active group' do
        Then  { expect(group.active_students).to eq([person_a, person_c]) }
      end

      context 'for graduated group' do
        Given { group.update_column(:graduated_at, Time.now - 1.day) }
        Given { person_a.student_profile.group_participations.first.update_column(:leave_date, Time.now - 2.day) }

        Then  { expect(group.active_students).to eq([person_b, person_c]) }
      end
    end
  end

  describe '#active?' do
    context 'active' do
      Given(:group) { create :academic_group }

      Then { expect(group.active?).to be(true) }
    end

    context 'graduated' do
      Given(:group) { create :academic_group, graduated_at: Time.now }

      Then { expect(group.active?).to be(false) }
    end
  end
end
