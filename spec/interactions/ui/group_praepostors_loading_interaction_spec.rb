require 'rails_helper'

describe Ui::GroupPraepostorsLoadingInteraction do
  describe '#as_json' do
    Given!(:right_user) { create :person, name: 'Vasyl' }
    Given!(:wrong_user_1) { create :person, name: 'Vasyl' }
    Given!(:wrong_user_2) { create :person, name: 'Vasyl' }

    Given(:group) { create :academic_group }
    Given(:interaction) { described_class.new(params: { q: 'vasy', group_id: group.id }) }

    Given { right_user.create_student_profile.move_to_group(group) }
    Given { wrong_user_1.create_student_profile }

    Given(:expected) do
      { people: [{ id: right_user.id,
                   text: right_user.complex_name,
                   imageUrl: right_user.photo.thumb.url }] }
    end

    Then { expect(interaction.as_json).to eq(expected) }
  end
end
