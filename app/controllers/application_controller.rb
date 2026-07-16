class ApplicationController < Sinatra::Base
  helpers AuthHelper
  helpers FlashHelper
  helpers ApplicationHelper
  helpers CartHelper

  configure do
    set :views, File.expand_path('../../views', __FILE__)
    set :public_folder, File.expand_path('../../../public', __FILE__)

    enable :sessions
    session_secret = ENV.fetch('SESSION_SECRET') do
      raise 'SESSION_SECRET não definida. Copie .env.example para .env e defina um valor (veja o README).'
    end
    set :session_secret, session_secret
  end

  get '/' do
    erb :'home/index', layout: :'layouts/application'
  end
end