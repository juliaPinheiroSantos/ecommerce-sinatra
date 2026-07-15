ENV['RACK_ENV'] = 'test'
require_relative '../config/environment' 
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  def app
    Rack::Builder.parse_file('config.ru')
  end

  config.before(:each) do
    ActiveRecord::Base.connection.begin_transaction(joinable: false)
  end

  config.after(:each) do
    ActiveRecord::Base.connection.rollback_transaction
  end
end