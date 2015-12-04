require 'rails_helper'
require 'pundit/rspec'

describe CertificateTemplatePolicy do
  subject { described_class }

  Given(:user)   { create(:person) }
  Given(:record) { create(:certificate_template) }

  context "given user's role activities" do
    %i(index? show? new? edit? create? update? destroy?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['certificate_template:' << action.to_s.sub('?', '')]
      end
    end
  end

  permissions :markup?, :finish?, :background? do
    it_behaves_like :allow_with_activities, %w(certificate_template:edit)
  end
end
