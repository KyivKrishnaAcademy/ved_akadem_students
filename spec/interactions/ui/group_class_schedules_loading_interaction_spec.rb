require 'rails_helper'

describe Ui::GroupClassSchedulesLoadingInteraction do
  Given(:user) { create :person }
  Given(:interaction) { described_class.new(user: user, params: { page: 1, id: 1 }) }

  describe 'calls ClassSchedule#personal_schedule' do
    Given(:result) { ClassSchedule.none.page(nil).per(1) }

    Then { expect(ClassSchedule).to receive(:by_group).with(1, 1).and_return(result) }
    And  { expect(interaction.as_json).to eq({ class_schedules: [], pages: 0 }) }
  end

  it_behaves_like :class_schedules_loadable
end
