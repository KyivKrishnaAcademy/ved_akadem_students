# require 'rails_helper'

describe Attendance do
  describe 'associations' do
    Then { is_expected.to belong_to(:student_profile) }
    Then { is_expected.to belong_to(:class_schedule) }
  end
end
