require 'rails_helper'
require 'pundit/rspec'

describe CertificatePolicy do
  subject { described_class }

  Given!(:user)   { create(:person) }
  Given!(:record) { create(:certificate) }

  context "given user's role activities" do
    %i(ui_create?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['certificate:' << action.to_s.sub('?', '')]
      end
    end
  end
end
