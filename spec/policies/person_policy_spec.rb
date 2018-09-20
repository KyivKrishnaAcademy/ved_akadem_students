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

      context 'classmate' do
        Given { record.create_student_profile.move_to_group(group) }

        context 'user can see classmate photo' do
          Then { is_expected.to permit(user, record) }
          And  { is_expected.to permit(record, user) }
        end

        context 'exclassmate' do
          When  { record.student_profile.group_participations.each(&:leave!) }

          context 'user can see exclassmate photo of graduated group' do
            Given { group.update_column(:graduated_at, Time.zone.now) }

            Then  { is_expected.to permit(user, record) }
            And   { is_expected.to permit(record, user) }
          end

          context 'user can not see excluded exclassmate photo of graduated group' do
            Given { group.update_column(:graduated_at, Time.zone.now + 1.day) }

            Then  { is_expected.not_to permit(user, record) }
            And   { is_expected.not_to permit(record, user) }
          end

          context 'user can not see exclassmate photo' do
            Then { is_expected.not_to permit(user, record) }
            And  { is_expected.not_to permit(record, user) }
          end
        end
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
      permissions :crop_image?, :update_image?, :show_photo? do
        it 'allow' do
          should permit(user, user)
        end
      end
    end

    %i(new? show? create? edit? index? destroy? update? crop_image?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['person:' << action.to_s.sub('?', '')]
      end
    end
  end
end
