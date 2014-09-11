require 'spec_helper'

describe 'Questionnaires' do
  Given { @question_1     = create :question, :boolean, data: { text: 'Чи ти в своєму розумі?' } }
  Given { @questionnaire  = create :questionnaire, title: 'Псих тест', questions: [@question_1] }
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
    When { visit edit_answer_path(@questionnaire) }

    Then { find('.questions').should have_css('.question', count: 1) }
    And  { find('.question').should have_css('.radio', count: 2) }
    And  { find('.question').should have_content('Чи ти в своєму розумі?')}
  end
end
