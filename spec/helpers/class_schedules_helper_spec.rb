require 'rails_helper'

describe ClassSchedulesHelper do
  describe '#class_schedule_title' do
    Given(:course) { create :course, title: 'Bhakti School' }
    Given(:classroom) { create :classroom, title: 'B4' }
    Given(:class_schedule) { create :class_schedule, course: course, classroom: classroom, start_time: '03.06.2015 12:30' }

    Then { expect(class_schedule_title(class_schedule)).to eq('Bhakti School, Ср 03.06.15 12:30, B4') }
  end
end
