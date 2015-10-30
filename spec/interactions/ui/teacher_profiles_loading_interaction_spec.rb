require 'rails_helper'

describe Ui::TeacherProfilesLoadingInteraction do
  Given(:interaction) { described_class.new(params: { q: 'vasy' }) }

  describe '#as_json' do
    Given(:right_user) { create :person, name: 'Vasyl' }
    Given(:wrong_user) { create :person }

    Given!(:right_profile) { create :teacher_profile, person: right_user }
    Given!(:wrong_profile) { create :teacher_profile, person: wrong_user }

    Given(:expected) do
      { teacher_profiles: [{ id: right_profile.id,
                             text: right_user.complex_name,
                             imageUrl: '/assets/fallback/person/thumb_default.png' }] }
    end

    Then { expect(interaction.as_json).to eq(expected) }
  end
end
