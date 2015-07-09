require 'rails_helper'
require 'pundit/rspec'

describe TeacherProfilePolicy do
  subject { TeacherProfilePolicy }

  Given(:user) { create(:person) }

  context 'complex conditions' do
    permissions :ui_index? do
      context 'permit with class_schedule:edit' do
        Given { user.roles << [create(:role, activities: %w(class_schedule:edit))] }

        Then  { is_expected.to permit(user, TeacherProfile) }
      end

      context 'permit with class_schedule:new' do
        Given { user.roles << [create(:role, activities: %w(class_schedule:new))] }

        Then  { is_expected.to permit(user, TeacherProfile) }
      end

      context 'permit with course:edit' do
        Given { user.roles << [create(:role, activities: %w(course:edit))] }

        Then  { is_expected.to permit(user, TeacherProfile) }
      end

      context 'permit with course:new' do
        Given { user.roles << [create(:role, activities: %w(course:new))] }

        Then  { is_expected.to permit(user, TeacherProfile) }
      end

      context 'not permit without roles' do
        Then  { is_expected.not_to permit(user, TeacherProfile) }
      end

      context 'not permit with all other' do
        Given(:permitted_activities) { %w(course:new course:edit class_schedule:edit class_schedule:new) }

        Given { user.roles << [create(:role, activities: all_activities - permitted_activities)] }

        Then  { is_expected.not_to permit(user, TeacherProfile) }
      end
    end
  end
end
