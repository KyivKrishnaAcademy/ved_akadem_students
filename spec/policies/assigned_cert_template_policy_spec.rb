require 'rails_helper'
require 'pundit/rspec'

describe AssignedCertTemplatePolicy do
  subject { described_class }

  Given!(:user)   { create(:person) }
  Given!(:record) { create(:assigned_cert_template) }

  context "given user's role activities" do
    %i(create? destroy?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['assigned_cert_template:' << action.to_s.sub('?', '')]
      end
    end
  end
end
