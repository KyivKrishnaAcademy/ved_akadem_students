require 'capistrano/setup'

require 'capistrano/deploy'
require 'airbrussh/capistrano'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

invoke :production
