# app/controllers/application_controller.rb
class ApplicationController < Sinatra::Base
  # Configuração comum de views e assets para todos os controladores herdados
  configure do
    set :views, File.expand_path('../../views', __FILE__)
    set :public_folder, File.expand_path('../../../public', __FILE__)
    enable :sessions
  end

  # Rota da Home page
  get '/' do
    # Você pode redirecionar para a listagem de produtos ou renderizar uma home
    "Testagem de rotas"
  end
end