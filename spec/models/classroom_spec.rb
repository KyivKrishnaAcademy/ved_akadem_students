require 'rails_helper'

describe Classroom do
  describe 'association' do
    Then { expect(subject).to have_many(:class_schedules ).dependent(:destroy) }
  end
end
