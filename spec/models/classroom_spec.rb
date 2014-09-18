require 'rails_helper'

describe Classroom do
  describe 'association' do
    Then { is_expected.to have_many(:class_schedules ).dependent(:destroy) }
  end
end
