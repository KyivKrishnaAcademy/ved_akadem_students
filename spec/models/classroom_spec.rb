require 'rails_helper'

describe Classroom do
  describe 'association' do
    Then { is_expected.to have_many(:class_schedules).dependent(:destroy) }
  end

  describe 'validations' do
    Then { is_expected.to validate_presence_of(:title) }
  end
end
