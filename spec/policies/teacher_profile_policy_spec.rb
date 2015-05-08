require 'rails_helper'
require 'pundit/rspec'

describe TeacherProfilePolicy do
  subject { TeacherProfilePolicy }

  Given(:user) { create(:person) }

  context 'complex conditions' do
    permissions :index? do
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
        Given { user.roles << [create(:role, activities: all_activities - %w(course:new course:edit))] }

        Then  { is_expected.not_to permit(user, TeacherProfile) }
      end
    end
  end
end
