if %w(development test).include? Rails.env
  namespace :lint do
    # This fails: https://github.com/bbatsov/rubocop/issues/1840
    # RuboCop::RakeTask.new
    # require "rubocop/rake_task"
    desc "Run Rubocop lint in shell. Specify option fix to auto-correct (and don't have uncommitted files!)."
    task :rubocop, [:fix] => [] do |_t, args|
      def to_bool(str)
        return true if str =~ (/^(true|t|yes|y|1)$/i)
        return false if str.blank? || str =~ (/^(false|f|no|n|0)$/i)
        fail ArgumentError, "invalid value for Boolean: \"#{str}\""
      end

      fix = (args.fix == "fix") || to_bool(args.fix)
      cmd = "rubocop -S -D#{fix ? ' -a' : ''} ."
      puts "Running Rubocop Linters via `#{cmd}`#{fix ? ' auto-correct is turned on!' : ''}"
      sh cmd
    end

    desc "Run ruby-lint as shell"
    task :ruby do
      cmd = "ruby-lint app config spec lib"
      puts "Running ruby-lint Linters via `#{cmd}`"
      sh cmd
    end

    desc "haml_lint"
    task :haml_lint do
      sh 'haml-lint app/views'
    end

    desc "eslint"
    task :eslint do
      cmd = "cd client && npm run eslint"
      puts "Running eslint via `#{cmd}`"
      sh cmd
    end

    desc "jscs"
    task :jscs do
      cmd = "cd client && npm run jscs"
      puts "Running jscs via `#{cmd}`"
      sh cmd
    end

    desc "JS Linting"
    task js: [:eslint, :jscs] do
      puts "Completed running all JavaScript Linters"
    end

    # task lint: [:rubocop, :ruby, :sass, :js, :haml_lint] do
    task lint: [:ruby, :js] do
      puts "Completed all linting"
    end
  end

  desc "Runs all linters. Run `rake -D lint` to see all available lint options"
  task lint: ["lint:lint"]
end
