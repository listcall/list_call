# environment variables
require 'dotenv'

Dotenv.load

require __dir__ + '/lib/env_settings'

# foundation tasks
require 'capistrano/setup'
require 'capistrano/deploy'

# plugin tasks
require 'capistrano/bundler'
require 'capistrano/rails/migrations'

require 'capistrano/scm/git'

install_plugin Capistrano::SCM::Git

# custom tasks from `lib/capistrano/tasks'
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
