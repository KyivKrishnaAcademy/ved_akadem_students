namespace :akadem do
  desc 'Create initial questionnaires'
  task create_questionnaires: :environment do
    puts 'Reading data...'

    psycho_test = YAML.load_file(Rails.root.join('spec/fixtures/questionnaires/psyho_test_2.yml'))

    puts 'Populating...'

    psycho_options        = { ru: psycho_test[:answers][:ru].to_a.map(&:reverse),
                              uk: psycho_test[:answers][:uk].to_a.map(&:reverse) }
    psycho_questionnaire  = Questionnaire.create!(
                              kind:           'psycho_test',
                              rule:           { keys: psycho_test[:keys], indexes: psycho_test[:indexes] },
                              title_uk:       psycho_test[:title_uk],
                              title_ru:       psycho_test[:title_ru],
                              description_uk: psycho_test[:description_uk],
                              description_ru: psycho_test[:description_ru],
                              questions:      psycho_test[:questions].map do |q|
                                                Question.new(format:    'single_select',
                                                             position:  q[:position],
                                                             data:      { text:       { uk: q[:question_uk],
                                                                                        ru: q[:question_ru] },
                                                                          options:    psycho_options,
                                                                          key:        q[:key],
                                                                          key_anwers: q[:key_answers].map(&:to_s) })
                                              end)

    initial_questionnaire = FactoryGirl.create :questionnaire, :initial

    puts 'Adding questionnaires to Study applications...'

    Program.all.each do |program|
      program.questionnaires << [psycho_questionnaire, initial_questionnaire]
    end

    puts 'Done.'
  end
end
