environment = ENV['APP_ENV'] || 'development'

database = case environment
when 'test'
  'db/test.sqlite3'
else
  'db/development.sqlite3'
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: database
)