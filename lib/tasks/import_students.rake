require 'csv'

namespace :academic do
  desc 'Import existing students'
  task import_students: :environment do
    puts 'Reading data...'

    ASHRAM            = 'ashram'
    BIRTHDAY          = 'birthday'
    DIVORCED          = 'развод'
    EDUCATION         = 'education'
    EMAILS            = 'emails'
    EMERGENCY_CONTACT = 'emergency_contact'
    FULL_NAME         = 'full_name'
    GENDER            = 'gender'
    GROUP             = 'group'
    IN_RELATIONSHIP   = 'гражданский брак'
    MALE              = 'м'
    MARRIED           = 'женат/замужем'
    PROFESSION        = 'profession'
    QUESTION_KEYS     = ('q1'..'q7').to_a
    QUESTIONNAIRE_ID  = Questionnaire.find_by!(kind: 'initial_questions').id
    SINGLE            = 'нет отношений'
    TELEPHONES        = 'telephones'
    TIME_FORMAT       = '%F-%H%M%S%L'
    WIDOWED           = 'вдовец/вдова'
    YES               = 'yes'

    QUESTION_IDS      = Question.where(questionnaire_id: QUESTIONNAIRE_ID)
                                .each_with_object({}) { |q, h| h[q.position] = q.id }
    MAPPED_ASHRAM     = { SINGLE => 'single', MARRIED => 'married', WIDOWED => 'widowed',
                          IN_RELATIONSHIP => 'in_relationship', DIVORCED => 'divorced' }


    def telephones(str)
      str.gsub(/[\(\)\-\s]/, '').split(',').map do |number|
        Telephone.new(phone: "+380 #{number[1..2]} #{number[3..5]} #{number[6..-1]}")
      end
    end

    def answers(row)
      QUESTION_KEYS.map do |key|
        Answer.new(question_id: QUESTION_IDS[key.last.to_i], data: row[key] ) if row[key].present?
      end.compact
    end

    def dash_if_blank(str)
      str.present? ? str : '-'
    end

    puts 'Creating students...'

    CSV.read(Rails.root.join('tmp/to_import.csv'), headers: true).each do |row|
      surname, name, middle_name = row[FULL_NAME].split(/\s+/)
      academic_group = AcademicGroup.find_by!(title: row[GROUP])
      password       = SecureRandom.hex(10)

      person = Person.create!(
        name: name,
        middle_name: middle_name,
        surname: surname,
        password: password,
        password_confirmation: password,
        email: row[EMAILS].present? ? row[EMAILS].split(',').last.strip : "fake.#{Time.now.strftime(TIME_FORMAT)}@example.com",
        education: dash_if_blank(row[EDUCATION]),
        gender: row[GENDER] == MALE,
        privacy_agreement: YES,
        birthday: row[BIRTHDAY],
        telephones: telephones(row[TELEPHONES]),
        work: dash_if_blank(row[PROFESSION]),
        marital_status: MAPPED_ASHRAM[row[ASHRAM]],
        emergency_contact: row[EMERGENCY_CONTACT],
        questionnaire_completenesses: [
          QuestionnaireCompleteness.new(questionnaire_id: QUESTIONNAIRE_ID,
                                        completed: QUESTION_KEYS.all? { |k| row[k].present? })
        ],
        answers: answers(row)
      )

      person.create_student_profile.move_to_group(academic_group)

      print '.'
    end

    puts "\nDone."
  end
end
