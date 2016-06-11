namespace :academic do
  desc 'Create initial study programs'
  task create_programs: :environment do
    puts 'Reading data...'

    programs = YAML.load_file(Rails.root.join('spec/fixtures/programs.yml'))

    puts 'Populating...'

    manager_id = Person.first.id

    programs.each do |p|
      Program.create!(
        visible:  p[:visible],
        title_uk: p[:title_uk],
        title_ru: p[:title_ru],
        manager_id: manager_id,
        courses_uk: p[:courses_uk],
        courses_ru: p[:courses_ru],
        description_uk: p[:description_uk],
        description_ru: p[:description_ru]
      )
    end if Program.all.none?

    puts 'Done.'
  end
end
