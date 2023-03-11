require 'rails_helper'

describe Ui::GroupCuratorsLoadingInteraction do
  Given(:interaction) { described_class.new(params: { q: 'vasy' }) }

  describe '#as_json' do
    Given!(:right_user) { create :person, name: 'Vasyl' }
    Given!(:wrong_user) { create :person, name: 'Vasyl' }

    Given { right_user.create_teacher_profile }

    Given(:expected) do
      {
        people: [
          {
            id: right_user.id,
            text: right_user.complex_name,
            imageUrl: right_user.photo.thumb.url
          }
        ],
        more: false
      }
    end

    Then { expect(interaction.as_json).to eq(expected) }
  end
end
