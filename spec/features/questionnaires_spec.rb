require 'rails_helper'

describe 'Questionnaires' do
  Given { @question_1     = create :question, :boolean , data: { text: { uk: 'Чи ти в своєму розумі?',
                                                                         ru: 'Ты в своем уме?' } } }
  Given { @question_2     = create :question, :freeform, data: { text: { uk: 'Яке Ваше відношення до ...',
                                                                         ru: 'Как Вы относитесь к?' } } }
  Given { @questionnaire  = create :questionnaire, title_uk: 'Псих тест', questions: [@question_1, @question_2] }
  Given { @program        = create :program, questionnaires: [@questionnaire] }
  Given { @person         = create :person }
  Given { StudyApplication.create(person: @person, program: @program) }
  Given { QuestionnaireCompleteness.create(person: @person, questionnaire: @questionnaire) }
  Given { login_as_user(@person) }

  describe 'should show pending questionnaires' do
    When { visit root_path }

    Then { expect(find('.pending-docs')).to have_link('Псих тест') }
  end

  describe 'answer the questions' do
    When { visit edit_answer_path(@questionnaire) }

    describe 'should have fields' do
      subject { find('.questions') }

      Then { is_expected.to have_css('.question', count: 2) }
      And  { is_expected.to have_css('.question input[type="radio"]', count: 2) }
      And  { is_expected.to have_content('Чи ти в своєму розумі?') }
      And  { is_expected.to have_css('.question textarea', count: 1) }
      And  { is_expected.to have_content('Яке Ваше відношення до ...') }
    end

    describe 'should not be in pending' do
      When { first('input[type="radio"]').set(true) }
      When { find('textarea').set('не знаю') }
      When { click_button 'Update Questionnaire' }

      Then { expect(find('.pending-docs')).not_to have_link('Псих тест') }
    end
  end
end
