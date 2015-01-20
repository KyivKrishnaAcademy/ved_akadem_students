require 'rails_helper'
require 'pundit/rspec'

describe AkademGroupPolicy do
  subject { AkademGroupPolicy }

  Given(:record) { create(:akadem_group) }
  Given(:user)   { create(:person) }

  context 'complex conditions' do
    permissions :show? do
      context 'user is student of ther group' do
        Given { user.create_student_profile.move_to_group(record) }

        Then  { is_expected.to permit(user, record) }
      end

      context 'user is curator of ther group' do
        Given { record.update(curator: user) }

        Then  { is_expected.to permit(user, record) }
      end

      context 'user is administrator of ther group' do
        Given { record.update(administrator: user) }

        Then  { is_expected.to permit(user, record) }
      end
    end
  end

  context 'given user\'s role activities' do
    permissions :autocomplete_person? do
      it_behaves_like :allow_with_activities, %w(akadem_group:edit)
    end

    [:new?, :create?, :edit?, :show?, :index?, :destroy?, :update?].each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['akadem_group:' << action.to_s.sub('?', '')]
      end
    end
  end
end
