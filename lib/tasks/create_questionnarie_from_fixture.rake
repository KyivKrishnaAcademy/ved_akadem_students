namespace :academic do
  desc 'Create questionnaire from fixture'
  task create_questionnaire_from_fixture: :environment do
    puts 'Reading data...'

    fixture = YAML.load_file(Rails.root.join('spec/fixtures/questionnaires/bhakti_vaibhava.yml'))

    puts 'Populating...'

    questionnaire = Questionnaire.create(fixture[:questionnaire])

    fixture[:questions].each do |q|
      Question.create(q.merge({questionnaire_id: questionnaire.id}))
    end

    puts 'Done.'
  end
end
