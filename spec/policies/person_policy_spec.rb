require 'spec_helper'

describe PersonPolicy do
  subject { PersonPolicy }

  let(:record) { create(:person) }
  let(:user)   { create(:person) }

  context 'given user\'s role activities' do
    [:show?, :show_photo?].each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, %w(person:show)

        context 'owned' do
          it 'allow' do
            should permit(user, user)
          end
        end
      end
    end

    permissions :crop_image? do
      context 'owned' do
        it 'allow' do
          should permit(user, user)
        end
      end
    end

    [:new?, :create?, :edit?, :index?, :destroy?, :update?, :crop_image?].each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['person:' << action.to_s.sub('?', '')]
      end
    end
  end
end
