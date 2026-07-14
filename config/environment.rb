# config/environment.rb
ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

# Configura o banco de dados
require File.expand_path('../database', __FILE__)

# Define o diretório raiz da aplicação
APP_ROOT = File.expand_path('../../', __FILE__)

# Carrega os Helpers, Services, Models e Controllers automaticamente
Dir.glob(File.join(APP_ROOT, 'app', 'helpers', '*.rb')).each { |f| require f }
Dir.glob(File.join(APP_ROOT, 'app', 'services', '*.rb')).each { |f| require f }
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).each { |f| require f }
Dir.glob(File.join(APP_ROOT, 'app', 'controllers', '*.rb')).each { |f| require f }

# Configuração global de diretórios para o Sinatra (opcional, dependendo do controller)
require File.expand_path('../routes', __FILE__)