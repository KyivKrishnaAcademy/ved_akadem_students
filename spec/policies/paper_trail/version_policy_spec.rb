require 'rails_helper'
require 'pundit/rspec'

describe PaperTrail::VersionPolicy do
  subject { described_class }

  Given(:user)   { create(:person) }
  Given(:record) { user.versions.last }

  context "given user's role activities" do
    permissions 'show?' do
      Given(:activities) { ['paper_trail/version:show'] }

      context 'allow' do
        Given { user.roles << create(:role, activities: activities) }

        Then  { is_expected.to permit(user, PaperTrail::Version) }
      end

      context 'disallow' do
        Given { user.roles << create(:role, activities: all_activities - activities) }

        Then  { is_expected.not_to permit(user, record) }
      end
    end
  end
end
