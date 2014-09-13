require 'rails_helper'

describe Attendance do
  describe 'associations' do
    Then { expect(subject).to belong_to(:student_profile ) }
    Then { expect(subject).to belong_to(:class_schedule ) }
  end
end
