require 'rails_helper'
require 'pundit/rspec'

describe QuestionnairePolicy do
  subject { QuestionnairePolicy }

  let(:owned_record)  do
    questionnaire = create(:questionnaire)

    QuestionnaireCompleteness.create(person: owner, questionnaire: questionnaire)

    questionnaire
  end
  let(:record) { create(:questionnaire) }
  let(:owner) { create :person }
  let(:user) { create(:person) }

  context 'given user\'s role activities' do
    permissions :show_form? do
      it_behaves_like :allow_with_activities, %w(questionnaire:update_all)
    end

    permissions :save_answers? do
      it_behaves_like :allow_with_activities, %w(questionnaire:update_all)
    end

    context 'owned' do
      permissions :show_form?, :save_answers? do
        it 'allow' do
          should permit(owner, owned_record)
        end
      end
    end
  end
end
