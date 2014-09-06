namespace :akadem do
  desc 'Create initial questionnaires'
  task create_questionnaires: :environment do
    puts 'Reading data...'

    psyho_test = YAML.load_file(Rails.root.join('spec/fixtures/questionnaires/psyho_test.yml'))

    puts 'Populating...'

    psyho_questionnaire = Questionnaire.create(
                            title:        psyho_test[:title],
                            description:  psyho_test[:description],
                            questions:    psyho_test[:questions].map { |q| Question.new(format: 'boolean', data: { text: q[:question]}) })

    puts 'Adding questionnaires to Study applications...'
    StudyApplication.all.each do |application|
      application.questionnaires << [psyho_questionnaire]
    end
    puts 'Done.'
  end
end
