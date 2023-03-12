require 'rails_helper'

describe Ui::CoursesLoadingInteraction do
  Given(:interaction) { described_class.new(params: { q: 'шко' }) }

  describe '#as_json' do
    Given!(:right_course) { create :course, title: 'Школа Бхакти' }

    Given { create :course, title: 'Университет Бхакти' }

    Given(:expected) do
      {
        courses: [
          { id: right_course.id, text: right_course.title }
        ],
        more: false
      }
    end

    Then { expect(interaction.as_json).to eq(expected) }
  end
end
