require 'rails_helper'

describe AnswersController do
  Given { @question       = create :question }
  Given { @questionnaire  = create :questionnaire, questions: [@question] }
  Given { @person         = create :person, :admin, questionnaires: [@questionnaire] }

  When { sign_in :person, @person }

  describe '#update' do
    describe 'wrong' do
      Given(:attributes) {
        { questions_attributes: { '0' => { answers_attributes: { '0' => { person_id: @person.id, data: nil } }, id: @question.id }}}
      }

      Then do
        expect_any_instance_of(Questionnaire).not_to receive(:complete!).with(@person.id)

        patch :update, { id: @questionnaire.id, questionnaire: attributes }
      end
    end

    describe 'right' do
      Given(:attributes) {
        { questions_attributes: { '0' => { answers_attributes: { '0' => { person_id: @person.id, data: 'some' } }, id: @question.id }}}
      }

      Then do
        expect_any_instance_of(Questionnaire).to receive(:complete!).with(@person.id)

        patch :update, { id: @questionnaire.id, questionnaire: attributes }
      end
    end
  end
end
