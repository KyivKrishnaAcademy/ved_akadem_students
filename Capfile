require 'capistrano/setup'

require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'whenever/capistrano'
require 'new_relic/recipes'
require 'capistrano/nvm'
require 'capistrano/npm'
require 'airbrussh/capistrano'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

invoke :production
