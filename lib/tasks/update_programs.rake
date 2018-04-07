namespace :academic do
  desc 'Update study programs'
  task update_programs: :environment do
    puts 'Reading data...'

    programs = YAML.load_file(Rails.root.join('spec', 'fixtures', 'programs.yml'))

    puts 'Populating...'

    programs.each { |p| Program.find_by(title_ru: p[:title_ru]).update(title_uk: p[:title_uk]) }

    puts 'Done.'
  end
end
