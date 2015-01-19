require 'rails_helper'
require 'pundit/rspec'

describe AkademGroupPolicy do
  subject { AkademGroupPolicy }

  let(:record) { create(:akadem_group) }
  let(:user)   { create(:person) }

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
