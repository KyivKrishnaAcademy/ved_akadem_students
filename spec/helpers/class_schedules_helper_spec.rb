require 'rails_helper'

describe ClassSchedulesHelper do
  describe '#class_schedule_title' do
    Given(:course) { create :course, title: 'Bhakti School' }
    Given(:classroom) { create :classroom, title: 'B4' }

    Given(:class_schedule) do
      create(
        :class_schedule,
        course: course,
        classroom: classroom,
        start_time: '03.06.2015 12:30',
        finish_time: '03.06.2015 12:45'
      )
    end

    Then { expect(class_schedule_title(class_schedule)).to eq('Bhakti School, Ср 03.06.15 12:30, B4') }
  end

  describe '#time_value' do
    Then { expect(time_value(nil)).to eq('') }
    Then { expect(time_value(Time.zone.parse('Ср 03.06.2015 12:30'))).to eq('03.06.2015 12:30') }
  end
end
