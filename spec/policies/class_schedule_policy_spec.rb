require 'rails_helper'
require 'pundit/rspec'

describe ClassSchedulePolicy do
  subject { ClassSchedulePolicy }

  let(:record) { ClassSchedule.create }
  let(:user)   { create(:person) }

  Then { expect(record).to be_persisted }
  context 'given user\'s role activities' do
    %i(index? show? new? edit? create? update? destroy?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['class_schedule:' << action.to_s.sub('?', '')]
      end
    end
  end
end
