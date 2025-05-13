# require 'rails_helper'

describe Ui::PersonClassSchedulesLoadingInteraction do
  Given(:user) { create :person }
  Given(:interaction) { described_class.new(user: user, params: { page: 1 }) }

  describe 'calls ClassSchedule#personal_schedule_by_direction' do
    Given(:result) { ClassSchedule.none.page(nil).per(1) }

    Then { expect(ClassScheduleWithPeople).to receive(:personal_schedule_by_direction).with(user.id, 1, nil).and_return(result) }
    And  { expect(interaction.as_json).to eq(classSchedules: [], pages: 0) }
  end

  it_behaves_like :class_schedules_loadable
end
