module PeopleHelper
  def not_adult_warning(birthday)
    content_tag(:span, t('people.show.not_adult'), class: :'text-danger') if birthday > 16.years.ago
  end

  def leave_reason(group_participation)
    academic_group = group_participation.academic_group

    if academic_group.graduated_at.present? && academic_group.graduated_at <= group_participation.leave_date
      'graduation'
    else
      'manual'
    end
  end

  def completed_initial_questionnaires(person)
    questionnaires = questionnaires_by_person(person)
    questions = questions_by_questionnaires(questionnaires)
    questions_by_questionnaire_id = indexed_questions_by_questionnaire_id(questions)
    answers_by_question_id = indexed_answers_by_question_id(questions, person)

    questionnaires.map do |questionnaire|
      questionnaire_hash = {
        uk: { title: questionnaire.title_uk, description: questionnaire.description_uk },
        ru: { title: questionnaire.title_ru, description: questionnaire.description_ru }
      }

      questions_hashes = questions_by_questionnaire_id[questionnaire.id].map do |question|
        {
          position: question.position,
          question_data: question.data,
          answer: answers_by_question_id[question.id].try(:data)
        }
      end

      [questionnaire_hash, questions_hashes]
    end.to_h
  end

  private

  def questionnaires_by_person(person)
    questionnaire_ids = QuestionnaireCompleteness
                          .where(completed: true, person: person)
                          .select(:questionnaire_id)

    Questionnaire
      .where(id: questionnaire_ids, kind: 'initial_questions')
      .order(:id)
      .select(:id, :description_uk, :description_ru, :title_uk, :title_ru)
  end

  def questions_by_questionnaires(questionnaires)
    Question
      .where(questionnaire_id: questionnaires.map(&:id))
      .order(:position)
      .select(:id, :data, :questionnaire_id, :position)
  end

  def indexed_answers_by_question_id(questions, person)
    Answer
      .where(question_id: questions.map(&:id), person: person)
      .index_by(&:question_id)
  end

  def indexed_questions_by_questionnaire_id(questions)
    questions.each_with_object({}) do |q, result|
      result[q.questionnaire_id] ||= []
      result[q.questionnaire_id] << q
    end
  end
end
