# config/environment.rb
ENV['RACK_ENV'] ||= 'development'

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