ENV['RACK_ENV'] ||= 'development'

env_file = File.expand_path('../.env', __dir__)
if File.exist?(env_file)
  File.readlines(env_file).each do |line|
    line = line.strip
    next if line.empty? || line.start_with?('#')

    key, value = line.split('=', 2)
    next unless key && value

    ENV[key.strip] ||= value.strip
  end
end

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require_relative 'database'

require File.expand_path('../database', __FILE__)

APP_ROOT = File.expand_path('../../', __FILE__)

Dir.glob('./app/helpers/*.rb').each { |file| require file }
Dir.glob('./app/models/*.rb').each { |file| require file }
Dir.glob('./app/services/*.rb').each { |file| require file } 
Dir.glob('./app/controllers/*.rb').each { |file| require file }

require File.expand_path('../routes', __FILE__)