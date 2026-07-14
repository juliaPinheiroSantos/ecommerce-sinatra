class ProfileController < ApplicationController
  helpers AuthHelper
  before do
    require_login!
  end

  get '/perfil' do
    erb :'profile/show', layout: :'layouts/application'
  end

  get '/perfil/editar' do
    erb :'profile/edit', layout: :'layouts/application'
  end

  post '/perfil/editar' do
    @user = current_user
    @user.nome = params[:nome]
    @user.telefone = params[:telefone]
    @user.cpf = params[:cpf]
    
    if params[:password] && !params[:password].strip.empty?
      @user.password = params[:password]
    end

    if @user.save
      redirect '/perfil'
    else
      @erros = @user.errors.full_messages
      erb :'profile/edit', layout: :'layouts/application'
    end
  end
end