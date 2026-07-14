class ApplicationController < Sinatra::Base
  helpers AuthHelper
  helpers FlashHelper
  helpers ApplicationHelper
  helpers CartHelper

  configure do
    set :views, File.expand_path('../../views', __FILE__)
    set :public_folder, File.expand_path('../../../public', __FILE__)

    enable :sessions
    set :session_secret, 'segredo_super_seguro_para_o_ecommerce_da_disciplina_de_programacao_web_com_sinatra_e_activerecord'
  end

  get '/' do
    erb :'home/index', layout: :'layouts/application'
  end
end