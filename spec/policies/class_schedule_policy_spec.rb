require 'rails_helper'
require 'pundit/rspec'

describe ClassSchedulePolicy do
  subject { ClassSchedulePolicy }

  Given(:user)   { create(:person) }
  Given(:record) { create(:class_schedule) }

  context 'given user\'s role activities' do
    %i(index? show? new? edit? create? update? destroy?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['class_schedule:' << action.to_s.sub('?', '')]
      end
    end
  end

  permissions :ui_person? do
    context 'no group, no teacher profile' do
      Then { is_expected.not_to permit(user, record) }
    end

    context 'with teacher profile' do
      Given { user.create_teacher_profile }

      Then { is_expected.to permit(user, record) }
    end

    context 'with group' do
      Given(:group) { create :academic_group }

      Given { user.create_student_profile.academic_groups << group }

      context 'active' do
        Then { is_expected.to permit(user, record) }
      end

      context 'inactive' do
        Given { user.student_profile.group_participations.first.leave! }

        Then  { is_expected.not_to permit(user, record) }
      end
    end
  end
end
