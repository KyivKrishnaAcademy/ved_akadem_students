require 'rails_helper'
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
    permissions :ui_index? do
      context 'permit with class_schedule:edit' do
        Given { user.roles << [create(:role, activities: %w(class_schedule:edit))] }

        Then  { is_expected.to permit(user, Course) }
      end

      context 'permit with class_schedule:new' do
        Given { user.roles << [create(:role, activities: %w(class_schedule:new))] }

        Then  { is_expected.to permit(user, Course) }
      end

      context 'not permit without roles' do
        Then  { is_expected.not_to permit(user, Course) }
      end

      context 'not permit with all other' do
        Given(:permitted_activities) { %w(class_schedule:edit class_schedule:new) }

        Given { user.roles << [create(:role, activities: all_activities - permitted_activities)] }

        Then  { is_expected.not_to permit(user, Course) }
      end
    end
  end
end
