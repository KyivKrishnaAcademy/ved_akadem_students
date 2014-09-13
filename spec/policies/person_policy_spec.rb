require 'rails_helper'
require 'pundit/rspec'

describe PersonPolicy do
  subject { PersonPolicy }

  let(:record) { create(:person) }
  let(:user)   { create(:person) }

  context 'given user\'s role activities' do
    permissions :show_photo? do
      it_behaves_like :allow_with_activities, %w(person:show)
    end

    permissions :update_image? do
      it_behaves_like :allow_with_activities, %w(person:crop_image)
    end

    context 'owned' do
      permissions :crop_image?, :update_image?, :show?, :show_photo?, :show_passport? do
        it 'allow' do
          should permit(user, user)
        end
      end
    end

    [:new?, :show?, :create?, :edit?, :index?, :destroy?, :update?, :crop_image?, :show_passport?].each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['person:' << action.to_s.sub('?', '')]
      end
    end
  end
end
