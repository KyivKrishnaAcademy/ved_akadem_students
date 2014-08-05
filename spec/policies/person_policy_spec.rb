require 'spec_helper'

describe PersonPolicy do
  subject { PersonPolicy }

  let(:record) { create(:person) }
  let(:user)   { create(:person) }

  context 'given user\'s role activities' do
    permissions :show? do
      it_behaves_like :allow_with_activities, %w(person:show)

      context 'show self' do
        it 'allow' do
          should permit(user, user)
        end
      end
    end

    [:new?, :create?, :edit?, :index?, :destroy?, :update?].each do |action|
      permissions action do
        context 'show self' do
          it_behaves_like :allow_with_activities, ['person:' << action.to_s.sub('?', '')]
        end
      end
    end
  end
end
