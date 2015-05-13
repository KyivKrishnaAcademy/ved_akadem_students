require 'rails_helper'
require 'pundit/rspec'

describe PersonPolicy do
  subject { PersonPolicy }

  Given(:record) { create(:person) }
  Given(:user)   { create(:person) }

  context 'complex conditions' do
    permissions :show_photo? do
      Given(:group) { create :academic_group }

      Given { user.create_student_profile.move_to_group(group) }

      context 'user can see classmate photo' do
        Given { record.create_student_profile.move_to_group(group) }

        Then  { is_expected.to permit(user, record) }
      end

      context 'user can not see exclassmate photo' do
        Given { record.create_student_profile.move_to_group(group) }
        Given { record.student_profile.remove_from_groups }

        Then  { is_expected.not_to permit(user, record) }
      end

      context 'user can see currator photo' do
        Given { group.update(curator: record) }

        Then  { is_expected.to permit(user, record) }
      end

      context 'user can see administrator photo' do
        Given { group.update(administrator: record) }

        Then  { is_expected.to permit(user, record) }
      end
    end
  end

  context 'given user\'s role activities' do
    permissions :group_admins_index? do
      it_behaves_like :allow_with_activities, %w(academic_group:edit academic_group:new)
    end

    permissions :group_curators_index? do
      it_behaves_like :allow_with_activities, %w(academic_group:edit academic_group:new)
    end

    permissions :group_praepostors_index? do
      it_behaves_like :allow_with_activities, %w(academic_group:edit academic_group:new)
    end

    permissions :show_photo? do
      it_behaves_like :allow_with_activities, %w(person:show)
    end

    permissions :update_image? do
      it_behaves_like :allow_with_activities, %w(person:crop_image)
    end

    context 'owned' do
      permissions :crop_image?, :update_image?, :show_photo?, :show_passport? do
        it 'allow' do
          should permit(user, user)
        end
      end
    end

    %i(new? show? create? edit? index? destroy? update? crop_image? show_passport?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['person:' << action.to_s.sub('?', '')]
      end
    end
  end
end
