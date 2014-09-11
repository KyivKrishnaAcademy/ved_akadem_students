require 'spec_helper'

describe 'Questionnaires' do
  Given { @question_1     = create :question, :boolean , data: { text: 'Чи ти в своєму розумі?' } }
  Given { @question_2     = create :question, :freeform, data: { text: 'Яке Ваше відношення до ...' } }
  Given { @questionnaire  = create :questionnaire, title: 'Псих тест', questions: [@question_1, @question_2] }
  Given { @program        = create :program, questionnaires: [@questionnaire] }
  Given { @person         = create :person }
  Given { StudyApplication.create(person: @person, program: @program) }
  Given { QuestionnaireCompleteness.create(person: @person, questionnaire: @questionnaire) }
  Given { login_as_user(@person) }

  describe 'should show pending questionnaires' do
    When { visit root_path }

    Then { find('.pending-docs').should have_link('Псих тест') }
  end

  describe 'answer the questions' do
    subject { find('.questions') }

    When { visit edit_answer_path(@questionnaire) }

    Then { should have_css('.question', count: 2) }
    And  { should have_css('.question input[type="radio"]', count: 2) }
    And  { should have_content('Чи ти в своєму розумі?') }
    And  { should have_css('.question textarea', count: 1) }
    And  { should have_content('Яке Ваше відношення до ...') }
  end
end
