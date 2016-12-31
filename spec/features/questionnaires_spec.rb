require 'rails_helper'

describe 'Questionnaires' do
  Given(:question_1) do
    create :question, :single_select, data: {
      text: {
        uk: 'Чи ти в своєму розумі?',
        ru: 'Ты в своем уме?'
      },
      options: {
        uk: [['Так', true], ['Ні', false]],
        ru: [['Да', true], ['Нет', false]]
      }
    }
  end

  Given(:question_2) do
    create :question, :freeform, data: {
      text: {
        uk: 'Яке Ваше відношення до ...',
        ru: 'Как Вы относитесь к?'
      }
    }
  end

  Given(:person) { create :person }
  Given(:program) { create :program, questionnaires: [questionnaire] }
  Given(:questionnaire) { create :questionnaire, title_uk: 'Псих тест', questions: [question_1, question_2] }

  Given { StudyApplication.create(person: person, program: program) }
  Given { QuestionnaireCompleteness.create(person: person, questionnaire: questionnaire) }

  When { login_as(person) }

  describe 'should show pending questionnaires' do
    When { visit root_path }

    Then { expect(find('.pending-docs')).to have_link('Псих тест') }
  end

  describe 'answer the questions' do
    When { visit edit_answer_path(questionnaire) }

    describe 'should have fields' do
      subject { find('body > .container-fluid') }

      Then { is_expected.to have_css('input[type="radio"]', count: 2) }
      And  { is_expected.to have_content('Чи ти в своєму розумі?') }
      And  { is_expected.to have_css('textarea', count: 1) }
      And  { is_expected.to have_content('Яке Ваше відношення до ...') }
    end

    describe 'should not be in pending' do
      When { first('input[type="radio"]').set(true) }
      When { find('textarea').set('не знаю') }
      When { click_button I18n.t('answers.edit.update') }

      Then { expect(find('.pending-docs')).not_to have_link('Псих тест') }
    end
  end
end
