# require 'rails_helper'
require 'pundit/rspec'

describe CoursePolicy do
  subject { CoursePolicy }

  let(:record) { Course.create }
  let(:user)   { create(:person) }

  context 'given user\'s role activities' do
    %i(index? show? new? edit? create? update? destroy?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['course:' << action.to_s.sub('?', '')]
      end
    end
  end

  context 'complex conditions' do
    it_behaves_like :class_schedule_ui_index
  end
end
