# require 'rails_helper'

describe AnswersController do
  Given(:person) { create :person, :admin, questionnaires: [questionnaire] }
  Given(:question) { create :question }
  Given(:questionnaire) { create :questionnaire, questions: [question] }

  When { sign_in person }

  describe '#update' do
    describe 'wrong' do
      Given(:attributes) do
        {
          questions_attributes: {
            '0' => {
              answers_attributes: {
                '0' => {
                  person_id: person.id,
                  data: nil
                }
              },
              id: question.id
            }
          }
        }
      end

      Then { expect(AnswersProcessorService).not_to receive(:new) }
      And  { expect_any_instance_of(AnswersProcessorService).not_to receive(:process!) }
      And  { patch :update, params: { id: questionnaire.id, questionnaire: attributes } }
      And  { expect(response).not_to redirect_to(root_path) }
      And  { expect(response).to render_template(:edit) }
    end

    describe 'right' do
      Given(:attributes) do
        {
          questions_attributes: {
            '0' => {
              answers_attributes: {
                '0' => {
                  person_id: person.id,
                  data: 'some'
                }
              },
              id: question.id
            }
          }
        }
      end

      Given(:answers_processor) { double(AnswersProcessorService) }

      Given do
        allow(AnswersProcessorService).to receive(:new).with(questionnaire, person).and_return(answers_processor)
      end

      Then { expect(answers_processor).to receive(:process!) }
      And  { patch :update, params: { id: questionnaire.id, questionnaire: attributes } }
      And  { expect(response).not_to render_template(:edit) }
      And  { expect(response).to redirect_to(root_path) }
    end
  end
end
