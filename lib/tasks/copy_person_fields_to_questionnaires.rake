namespace :academic do
  desc 'Copy person fields to questionnaires'
  task copy_person_fields_to_questionnaires: :environment do
    puts 'Reading data...'

    education_and_occupation_fixture = YAML.load_file(
      Rails.root.join('spec/fixtures/questionnaires/education_and_occupation.yml')
    )

    friends_fixture = YAML.load_file(
      Rails.root.join('spec/fixtures/questionnaires/friends.yml')
    )

    marital_status_fixture = YAML.load_file(
      Rails.root.join('spec/fixtures/questionnaires/marital_status.yml')
    )

    favorite_lectors_fixture = YAML.load_file(
      Rails.root.join('spec/fixtures/questionnaires/favorite_lectors.yml')
    )

    puts 'Populating questions...'

    education_and_occupation_questionnaire = Questionnaire.find_or_create_by(
      education_and_occupation_fixture[:questionnaire]
    )

    education_fixture = education_and_occupation_fixture[:questions][:education]
    education_question = Question.find_or_create_by(
      position: education_fixture[:position],
      format: education_fixture[:format],
      questionnaire: education_and_occupation_questionnaire
    ) do |question|
      question.data = education_fixture[:data]
    end

    occupation_fixture = education_and_occupation_fixture[:questions][:occupation]
    occupation_question = Question.find_or_create_by(
      position: occupation_fixture[:position],
      format: occupation_fixture[:format],
      questionnaire: education_and_occupation_questionnaire
    ) do |question|
      question.data = occupation_fixture[:data]
    end

    friends_questionnaire = Questionnaire.find_or_create_by(
      friends_fixture[:questionnaire]
    )

    friends_question_fixture = friends_fixture[:questions][:friends]
    friends_question = Question.find_or_create_by(
      position: friends_question_fixture[:position],
      format: friends_question_fixture[:format],
      questionnaire: friends_questionnaire
    ) do |question|
      question.data = friends_question_fixture[:data]
    end

    marital_status_questionnaire = Questionnaire.find_or_create_by(
      marital_status_fixture[:questionnaire]
    )

    marital_status_question_fixture = marital_status_fixture[:questions][:marital_status]
    marital_status_question = Question.find_or_create_by(
      position: marital_status_question_fixture[:position],
      format: marital_status_question_fixture[:format],
      questionnaire: marital_status_questionnaire
    ) do |question|
      question.data = marital_status_question_fixture[:data]
    end

    favorite_lectors_questionnaire = Questionnaire.find_or_create_by(
      favorite_lectors_fixture[:questionnaire]
    )

    favorite_lectors_question_fixture = favorite_lectors_fixture[:questions][:favorite_lectors]
    favorite_lectors_question = Question.find_or_create_by(
      position: favorite_lectors_question_fixture[:position],
      format: favorite_lectors_question_fixture[:format],
      questionnaire: favorite_lectors_questionnaire
    ) do |question|
      question.data = favorite_lectors_question_fixture[:data]
    end

    puts 'Populating answers...'

    Person.all.each do |person|
      print '.'

      education_answer = Answer.find_or_create_by(question: education_question, person: person) do |answer|
        answer.data = person.education.strip
      end unless person.education.blank?

      occupation_answer = Answer.find_or_create_by(question: occupation_question, person: person) do |answer|
        answer.data = person.work.strip
      end unless person.work.blank?

      QuestionnaireCompleteness.find_or_create_by(
        person: person,
        questionnaire: education_and_occupation_questionnaire,
        result: {},
        completed: true
      ) if education_answer || occupation_answer

      friends_answer = Answer.find_or_create_by(question: friends_question, person: person) do |answer|
        answer.data = person.friends_to_be_with.strip
      end unless person.friends_to_be_with.blank?

      QuestionnaireCompleteness.find_or_create_by(
        person: person,
        questionnaire: friends_questionnaire,
        result: {},
        completed: true
      ) if friends_answer

      marital_status_answer = Answer.find_or_create_by(question: marital_status_question, person: person) do |answer|
        answer.data = person.marital_status
      end unless person.marital_status.blank?

      QuestionnaireCompleteness.find_or_create_by(
        person: person,
        questionnaire: marital_status_questionnaire,
        result: {},
        completed: true
      ) if marital_status_answer

      favorite_lectors_answer = Answer.find_or_create_by(question: favorite_lectors_question, person: person) do |answer|
        answer.data = person.favorite_lectors.strip
      end unless person.favorite_lectors.blank?

      QuestionnaireCompleteness.find_or_create_by(
        person: person,
        questionnaire: favorite_lectors_questionnaire,
        result: {},
        completed: true
      ) if favorite_lectors_answer
    end

    puts "\nDone."
  end
end
