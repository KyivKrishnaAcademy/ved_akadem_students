require 'rails_helper'

describe AnswersController do
  Given { @question       = create :question }
  Given { @questionnaire  = create :questionnaire, questions: [@question] }
  Given { @person         = create :person, :admin, questionnaires: [@questionnaire] }

  When { sign_in :person, @person }

  describe '#update' do
    describe 'wrong' do
      Given(:attributes) {
        { questions_attributes:
              { '0' => { answers_attributes: { '0' => { person_id: @person.id, data: nil } }, id: @question.id }}
        }
      }

      Then { expect(AnswersProcessorService).not_to receive(:new) }
      And  { expect_any_instance_of(AnswersProcessorService).not_to receive(:process!) }
      And  { patch :update, { id: @questionnaire.id, questionnaire: attributes } }
      And  { expect(response).not_to redirect_to(root_path) }
      And  { expect(response).to render_template(:edit) }
    end

    describe 'right' do
      Given(:attributes) {
        { questions_attributes:
              { '0' => { answers_attributes: { '0' => { person_id: @person.id, data: 'some' } }, id: @question.id }}
        }
      }
      Given(:answers_processor) { double(AnswersProcessorService) }

      Given { allow(AnswersProcessorService).to receive(:new).with(@questionnaire, @person).and_return(answers_processor) }

      Then { expect(answers_processor).to receive(:process!) }
      And  { patch :update, { id: @questionnaire.id, questionnaire: attributes } }
      And  { expect(response).not_to render_template(:edit) }
      And  { expect(response).to redirect_to(root_path) }
    end
  end
end
