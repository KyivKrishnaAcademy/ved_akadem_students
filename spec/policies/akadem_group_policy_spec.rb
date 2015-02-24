require 'rails_helper'
require 'pundit/rspec'

describe AcademicGroupPolicy do
  subject { AcademicGroupPolicy }

  Given(:record) { create(:academic_group) }
  Given(:user)   { create(:person) }

  context 'complex conditions' do
    permissions :show? do
      context 'user is student of the group' do
        Given { user.create_student_profile.move_to_group(record) }

        Then  { is_expected.to permit(user, record) }
      end

      context 'user is curator of the group' do
        Given { record.update(curator: user) }

        Then  { is_expected.to permit(user, record) }
      end

      context 'user is administrator of the group' do
        Given { record.update(administrator: user) }

        Then  { is_expected.to permit(user, record) }
      end
    end
  end

  context 'given user\'s role activities' do
    permissions :autocomplete_person? do
      it_behaves_like :allow_with_activities, %w(academic_group:edit)
    end

    %i(new? create? edit? show? index? destroy? update?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['academic_group:' << action.to_s.sub('?', '')]
      end
    end
  end
end
