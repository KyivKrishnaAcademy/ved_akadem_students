namespace :academic do
  desc 'Update questionnaires'
  task update_questionnaires: :environment do
    puts 'Reading data...'

    psyho_test = YAML.load_file(Rails.root.join('spec', 'fixtures', 'questionnaires', 'psyho_test.yml'))

    puts 'Populating...'

    Questionnaire
      .find_by(title_uk: psyho_test[:title_uk])
      .update(
        description_uk: psyho_test[:description_uk],
        description_ru: psyho_test[:description_ru]
      )

    puts 'Done.'
  end
end
