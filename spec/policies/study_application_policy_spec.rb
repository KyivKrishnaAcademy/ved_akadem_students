require 'spec_helper'

describe StudyApplicationPolicy do
  subject { StudyApplicationPolicy }

  before { @owner = create :person }
  let(:owned_record)  { StudyApplication.create(person: @owner, program: create(:program)) }
  let(:record)        { StudyApplication.create(person: create(:person), program: create(:program)) }
  let(:user)          { create(:person) }

  context 'given user\'s role activities' do
    context 'owned' do
      permissions :create?, :destroy? do
        it 'allow' do
          should permit(@owner, owned_record)
        end
      end
    end

    [:create?, :destroy?].each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['study_application:' << action.to_s.sub('?', '')]
      end
    end
  end
end
