require 'csv'

# rubocop:disable all
namespace :academic do
  desc 'Import existing students'
  task import_students: :environment do
    puts 'Reading data...'

    ASHRAM            = 'ashram'.freeze
    BIRTHDAY          = 'birthday'.freeze
    DIVORCED          = 'развод'.freeze
    EDUCATION         = 'education'.freeze
    EMAILS            = 'emails'.freeze
    FULL_NAME         = 'full_name'.freeze
    GENDER            = 'gender'.freeze
    GROUP             = 'group'.freeze
    IN_RELATIONSHIP   = 'гражданский брак'.freeze
    MALE              = 'м'.freeze
    MARRIED           = 'женат/замужем'.freeze
    PROFESSION        = 'profession'.freeze
    QUESTION_KEYS     = ('q1'..'q7').to_a
    QUESTIONNAIRE_ID  = Questionnaire.find_by!(kind: 'initial_questions').id
    SINGLE            = 'нет отношений'.freeze
    TELEPHONES        = 'telephones'.freeze
    TIME_FORMAT       = '%F-%H%M%S%L'.freeze
    WIDOWED           = 'вдовец/вдова'.freeze
    YES               = 'yes'.freeze

    QUESTION_IDS      = Question
                          .where(questionnaire_id: QUESTIONNAIRE_ID)
                          .each_with_object({}) { |q, h| h[q.position] = q.id }

    MAPPED_ASHRAM     = {
      SINGLE => 'single',
      MARRIED => 'married',
      WIDOWED => 'widowed',
      IN_RELATIONSHIP => 'in_relationship',
      DIVORCED => 'divorced'
    }.freeze

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
      str.presence || '-'
    end

    puts 'Creating students...'

    CSV.read(Rails.root.join('tmp', 'to_import.csv'), headers: true).each do |row|
      surname, name, middle_name = row[FULL_NAME].split(/\s+/)
      academic_group = AcademicGroup.find_by!(title: row[GROUP])
      password = SecureRandom.hex(10)
      now = Time.zone.now.strftime(TIME_FORMAT)

      person = Person.create!(
        name: name,
        middle_name: middle_name,
        surname: surname,
        password: password,
        password_confirmation: password,
        email: row[EMAILS].present? ? row[EMAILS].split(',').last.strip : "fake.#{now}@example.com",
        education: dash_if_blank(row[EDUCATION]),
        gender: row[GENDER] == MALE,
        privacy_agreement: YES,
        birthday: row[BIRTHDAY],
        telephones: telephones(row[TELEPHONES]),
        work: dash_if_blank(row[PROFESSION]),
        marital_status: MAPPED_ASHRAM[row[ASHRAM]],
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
