require 'active_record'

db_configuration = {
  'development' => {
    'adapter' => 'sqlite3',
    'database' => 'db/development.sqlite3'
  },
  'test' => {
    'adapter' => 'sqlite3',
    'database' => 'db/test.sqlite3'
  },
  'production' => {
    'adapter' => 'sqlite3',
    'database' => 'db/production.sqlite3'
  }
}

ActiveRecord::Base.configurations = db_configuration

current_env = ENV['RACK_ENV'] || 'development'
ActiveRecord::Base.establish_connection(db_configuration[current_env])

ActiveRecord::Base.logger = Logger.new(STDOUT) if current_env == 'development'