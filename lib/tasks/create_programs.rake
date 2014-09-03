namespace :akadem do
  desc 'Create initial study programs'
  task create_programs: :environment do
    puts 'Reading data...'

    programs = YAML.load_file(Rails.root.join('spec/fixtures/programs.yml'))

    puts 'Populating...'

    programs.each { |p| Program.create!(title: p[:title], description: p[:description]) } if Program.all.none?

    puts 'Done.'
  end
end
