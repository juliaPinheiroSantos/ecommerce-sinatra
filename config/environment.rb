# config/environment.rb
ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require_relative 'database'

require File.expand_path('../database', __FILE__)

APP_ROOT = File.expand_path('../../', __FILE__)

Dir.glob(File.join(APP_ROOT, 'app', 'helpers', '*.rb')).each { |f| require f }
Dir.glob(File.join(APP_ROOT, 'app', 'services', '*.rb')).each { |f| require f }
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).each { |f| require f }
Dir.glob(File.join(APP_ROOT, 'app', 'controllers', '*.rb')).each { |f| require f }

require File.expand_path('../routes', __FILE__)